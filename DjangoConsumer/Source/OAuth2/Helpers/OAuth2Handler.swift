//
//  OAuth2Handler.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - OAuth2Settings
// MARK: ???: Should this be a protocol, too? Check RFC
public struct OAuth2Settings {
    // Init
    public init(appSecret: String, tokenRequestURL: URL, tokenRefreshURL: URL, tokenRevokeURL: URL) {
        self.appSecret = appSecret
        self.tokenRequestURL = tokenRequestURL
        self.tokenRefreshURL = tokenRefreshURL
        self.tokenRevokeURL = tokenRevokeURL
    }
    
    // Public Variables
    public private(set) var appSecret: String
    public private(set) var tokenRequestURL: URL
    public private(set) var tokenRefreshURL: URL
    public private(set) var tokenRevokeURL: URL
}


// MARK: - OAuth2CredentialStore
public protocol OAuth2CredentialStore {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var expiryDate: Date? { get set }
    var tokenType: String? { get set }
    var scope: String? { get set }
    mutating func updateWith(accessToken: String, refreshToken: String, expiryDate: Date, tokenType: String, scope: String)
    mutating func clear()
}


// MARK: - OAuth2Error
enum OAuth2Error: Error {
    case noAccessToken
    case noRefreshToken
    case unmappableRequestTokensResponse(JSON)
}


// MARK: - OAuth2Handler
open class OAuth2Handler: RequestAdapter, RequestRetrier {
    // Init
    public init(settings: OAuth2Settings, credentialStore: OAuth2CredentialStore) {
        self.settings = settings
        self.credentialStore = credentialStore
    }
    
    // Overridable Readonly Lazy Variables
    open private(set) lazy var authenticatedSessionManager: SessionManagerType = self._createAuthenticatedSessionManager()
    
    // Public Variables
    public var settings: OAuth2Settings
    public var credentialStore: OAuth2CredentialStore
    
    // Private Lazy Variables
    private lazy var _authRequestSessionManager: SessionManagerType = self._createAuthRequestSessionManager()
    private lazy var _weakSelf: _Weak = { _Weak(self) }()
    
    // Private Variables
    private var _requestsToRetry: [RequestRetryCompletion] = []
    private var _lock: NSLock = NSLock()
    private var _isRefreshing: Bool = false
    private var _isRequesting: Bool = false
    
    
    // Overridables
    open func requestTokens(username: String, password: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        self._requestTokens(username: username, password: password, success: success, failure: failure)
    }
    
    open func refreshTokens(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        self._refreshTokens(success: success, failure: failure)
    }
    
    open func revokeTokens() {
        self._revokeTokens()
    }
    
    // RequestAdapter
    open func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return try self._addBearerAuthorizationHeader(to: urlRequest)
    }
    
    // RequestRetrier
    open func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._should(manager, retry: request, with: error, completion: completion)
    }
}


// MARK: // Private
// MARK: - Typealiases
private typealias _C = OAuth2Constants


// MARK: - _WrappedRequestRetrier
// This wrapper class is needed to prevent strong reference cycles.
private class _Weak: RequestAdapter, RequestRetrier {
    // Init
    init(_ handler: OAuth2Handler) {
        self._handler = handler
    }
    
    // Weak Variables
    private weak var _handler: OAuth2Handler?
    
    // RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return try self._handler?.adapt(urlRequest) ?? urlRequest
    }
    
    // RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._handler?.should(manager, retry: request, with: error, completion: completion)
    }
}


// MARK: - _TokenResponse
private struct _TokenResponse {
    init?(json: JSON) {
        guard
            let accessToken: String = json[_C.JSONKeys.accessToken].string,
            let refreshToken: String = json[_C.JSONKeys.refreshToken].string,
            let expiresIn: TimeInterval = json[_C.JSONKeys.expiresIn].double,
            let tokenType: String = json[_C.JSONKeys.tokenType].string,
            let scope: String = json[_C.JSONKeys.scope].string
        else { return nil }
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        // ???: Should a tolerance be subtracted from expiresIn to account for request duration?
        self.expiryDate = Date().addingTimeInterval(expiresIn)
        self.tokenType = tokenType
        self.scope = scope
    }
    
    private(set) var accessToken: String
    private(set) var refreshToken: String
    private(set) var expiryDate: Date
    private(set) var tokenType: String
    private(set) var scope: String
}


// MARK: - OAuth2Handler
// MARK: Lazy Variable Creation
private extension OAuth2Handler {
    func _createAuthenticatedSessionManager() -> SessionManagerType {
        let sessionManager: SessionManager = .makeDefault()
        sessionManager.retrier = self._weakSelf
        sessionManager.adapter = self._weakSelf
        return sessionManager
    }
    
    func _createAuthRequestSessionManager() -> SessionManagerType {
        let sessionManager: SessionManager = .makeDefault()
        sessionManager.retrier = self._weakSelf
        return sessionManager
    }
}


// MARK: Authorization Headers
private extension OAuth2Handler {
    typealias _Header = (key: String, value: String)
    
    func _addBearerAuthorizationHeader(to urlRequest: URLRequest) throws -> URLRequest {
        guard let bearerAuthHeader: _Header = self._bearerAuthHeader() else {
            throw OAuth2Error.noAccessToken
        }
        
        var urlRequest: URLRequest = urlRequest
        urlRequest.setValue(bearerAuthHeader.value, forHTTPHeaderField: bearerAuthHeader.key)
        return urlRequest
    }
    
    // ???: Does it make sense to compute these everytime?
    // Storing them somewhere as state is less expensive but adds more variables that have
    // to be synchronized and updated in auth requests in order to avoid possible race conditions.
    func _basicAuthHeader() -> _Header {
        return (_C.HeaderFields.authorization, _C.HeaderValues.basic(self.settings.appSecret))
    }
    
    func _bearerAuthHeader() -> _Header? {
        guard let accessToken: String = self.credentialStore.accessToken else { return nil }
        return (_C.HeaderFields.authorization, _C.HeaderValues.bearer(accessToken))
    }
}


// MARK: RequestRetrier
private extension OAuth2Handler/*: RequestRetrier*/ {
    func _should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._lock.try()
        
        guard let url: URL = request.request?.url else {
            completion(false, 0.0)
            return
        }
        
        switch url {
        // TODO: Implement client callbacks
        case self.settings.tokenRequestURL: break
        case self.settings.tokenRefreshURL: break
        case self.settings.tokenRevokeURL: break
        default:
            break
        }
        
        // ???: Should there be checks for more error codes like 429, for example?
        guard let response: HTTPURLResponse = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }
        
        self._requestsToRetry.append(completion)
        
        self._refreshTokens(
            success: { self._processRequestsToRetry(shouldRetry: true, clear: true) },
            failure: { error in
                switch error {
                case OAuth2Error.noRefreshToken:
                    self._processRequestsToRetry(shouldRetry: false, clear: true)
                    // ???: Clear CredentialStore
                default: break
                }
            }
        )
        
        self._lock.unlock()
    }
    
    private func _processRequestsToRetry(shouldRetry: Bool, clear: Bool) {
        self._requestsToRetry.forEach({ $0(shouldRetry, 0.0) })
        if clear { self._requestsToRetry = [] }
    }
}


// MARK: Token Request Implementation
private extension OAuth2Handler {
    func _requestTokens(username: String, password: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard !self._isRequesting else { return }
        self._isRequesting = true
        
        let url: URL = self.settings.tokenRequestURL
        let parameters: [String : Any] = [
            _C.JSONKeys.grantType : _C.GrantTypes.password,
            _C.JSONKeys.scope : _C.Scopes.readWrite,
            _C.JSONKeys.username : username,
            _C.JSONKeys.password : password
        ]
        
        self.__requestAndSaveTokens(
            url: url,
            parameters: parameters,
            updateStatus: { self._isRequesting = false },
            success: success,
            failure: failure
        )
    }
}


// MARK: Token Refresh Implementation
private extension OAuth2Handler {
    func _refreshTokens(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard !self._isRefreshing else { return }
        self._isRefreshing = true
        
        guard let refreshToken: String = self.credentialStore.refreshToken else {
            failure(OAuth2Error.noRefreshToken)
            return
        }
        
        let url: URL = self.settings.tokenRefreshURL
        let parameters: [String : Any] = [
            _C.JSONKeys.refreshToken: refreshToken,
            _C.JSONKeys.grantType: _C.GrantTypes.refreshToken
        ]
        
        self.__requestAndSaveTokens(
            url: url,
            parameters: parameters,
            updateStatus: { self._isRefreshing = false },
            success: success,
            failure: failure
        )
    }
}


// MARK: Common Token Request Functionality
private extension OAuth2Handler {
    func __requestAndSaveTokens(url: URL, parameters: Parameters, updateStatus: @escaping () -> Void, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let basicAuthHeader: _Header = self._basicAuthHeader()
        
        let cfg: RequestConfiguration = {
            RequestConfiguration(
                url: url,
                method: .post,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: [basicAuthHeader.key : basicAuthHeader.value]
            )
        }()
        
        let responseHandling: JSONResponseHandling = {
            JSONResponseHandling(
                onSuccess: { self._handleSuccessfulTokenRequest(json: $0, updateStatus: updateStatus, success: success, failure: failure) },
                onFailure: { self._handleFailedTokenRequest(error: $0, updateStatus: updateStatus, failure: failure) }
            )
        }()
        
        self._authRequestSessionManager.fireJSONRequest(with: cfg, responseHandling: responseHandling)
    }
    
    func _handleSuccessfulTokenRequest(json: JSON, updateStatus: @escaping () -> Void, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        self._lock.try()
        
        guard let tokenResponse: _TokenResponse = _TokenResponse(json: json) else {
            failure(OAuth2Error.unmappableRequestTokensResponse(json))
            // We don't need to update the status and unlock here, since this is done
            // inside the onFailure function (declared above).
            return
        }
        
        self._updateCredentialStore(with: tokenResponse)
        
        updateStatus()
        success()
        self._lock.unlock()
    }
    
    func _handleFailedTokenRequest(error: Error, updateStatus: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        self._lock.try()
        updateStatus()
        failure(error)
        self._lock.unlock()
    }
    
    func _updateCredentialStore(with tokenResponse: _TokenResponse) {
        self.credentialStore.updateWith(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken,
            expiryDate: tokenResponse.expiryDate,
            tokenType: tokenResponse.tokenType,
            scope: tokenResponse.scope
        )
    }
}


// MARK: Token Revoke Implementation
private extension OAuth2Handler {
    func _revokeTokens() {
        guard let accessToken: String = self.credentialStore.accessToken else {
            // ???: Should the credentialStore be cleared here?
            return
        }
        
        let basicAuthHeader: _Header = self._basicAuthHeader()
        
        let cfg: RequestConfiguration = RequestConfiguration(
            url: self.settings.tokenRevokeURL,
            method: .post,
            parameters: [_C.JSONKeys.token : accessToken],
            encoding: URLEncoding.default,
            headers: [basicAuthHeader.key : basicAuthHeader.value]
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in },
            onFailure: { _ in }
        )
        
        self._authRequestSessionManager.fireJSONRequest(with: cfg, responseHandling: responseHandling)
        
        // ???: I suppose it's cleaner to clear the credentialStore synchronously
        // instead of waiting for the request to receive a response. Is it though?
        self.credentialStore.clear()
    }
}
