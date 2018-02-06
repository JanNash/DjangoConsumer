//
//  DRFOAuth2Handler.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - DRFOAuth2Settings
// MARK: ???: Should this be a protocol, too? Check RFC
public struct DRFOAuth2Settings {
    // Init
    public init(appSecret: String, tokenRequestURL: URL, tokenRefreshURL: URL, tokenRevokeURL: URL) {
        self.appSecret = appSecret
        self.tokenRequestURL = tokenRequestURL
        self.tokenRefreshURL = tokenRefreshURL
        self.tokenRevokeURL = tokenRevokeURL
    }
    
    // Public Variables
    public var appSecret: String
    public var tokenRequestURL: URL
    public var tokenRefreshURL: URL
    public var tokenRevokeURL: URL
}


// MARK: - DRFOAuth2CredentialStore
public protocol DRFOAuth2CredentialStore {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var expiryDate: Date? { get set }
    mutating func updateWith(accessToken: String, refreshToken: String, expiryDate: Date)
    mutating func clear()
}


// MARK: - DRFOAuth2Error
enum DRFOAuth2Error: Error {
    case noCredentials
}


// MARK: - DRFOAuth2Handler
open class DRFOAuth2Handler: RequestAdapter, RequestRetrier {
    // Init
    init(settings: DRFOAuth2Settings, credentialStore: DRFOAuth2CredentialStore) {
        self._settings = settings
        self._credentialStore = credentialStore
    }
    
    // Private Lazy Variables
    private lazy var _sessionManager: SessionManager = self._createSessionManager()
    private lazy var _weakSelf: _Weak = { _Weak(self) }()
    
    // Private Variables
    private var _settings: DRFOAuth2Settings
    private var _credentialStore: DRFOAuth2CredentialStore
    private var _requestsToRetry: [RequestRetryCompletion] = []
    private var _lock: NSLock = NSLock()
    private var _isRefreshing: Bool = false
    private var _isRequesting: Bool = false
    
    
    // Overridables
    open func requestTokens(username: String, password: String) {
        self._requestTokens(username: username, password: password)
    }
    
    open func refreshTokens() {
        self._refreshTokens()
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
private typealias _C = DRFOAuth2Constants


// MARK: - _WrappedRequestRetrier
// This wrapper class is needed because a DRFOAuth2Handler assigns itself as the retrier
// for its own sessionManager. Without the wrapper, this would create a strong reference cycle.
private class _Weak: RequestRetrier {
    // Init
    init(_ handler: DRFOAuth2Handler) {
        self._handler = handler
    }
    
    // Weak Variables
    private weak var _handler: DRFOAuth2Handler?
    
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


// MARK: - DRFOAuth2Handler
// MARK: Lazy Variable Creation
private extension DRFOAuth2Handler {
    func _createSessionManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionManager: SessionManager = SessionManager(configuration: configuration)
        sessionManager.retrier = self._weakSelf
        return sessionManager
    }
}


// MARK: Authorization Headers
private extension DRFOAuth2Handler {
    typealias _Header = (key: String, value: String)
    
    func _addBearerAuthorizationHeader(to urlRequest: URLRequest) throws -> URLRequest {
        guard let bearerAuthHeader: _Header = self._bearerAuthHeader() else {
            throw DRFOAuth2Error.noCredentials
        }
        
        var urlRequest: URLRequest = urlRequest
        urlRequest.setValue(bearerAuthHeader.value, forHTTPHeaderField: bearerAuthHeader.key)
        return urlRequest
    }
    
    // ???: Does it make sense to compute these everytime?
    // Storing them somewhere as state is less expensive but adds more variables that have
    // to be synchronized and updated in auth requests in order to avoid possible race conditions.
    func _basicAuthHeader() -> _Header {
        return (_C.HeaderFields.authorization, _C.HeaderValues.basic(self._settings.appSecret))
    }
    
    func _bearerAuthHeader() -> _Header? {
        guard let accessToken: String = self._credentialStore.accessToken else { return nil }
        return (_C.HeaderFields.authorization, _C.HeaderValues.bearer(accessToken))
    }
}


// MARK: RequestRetrier
private extension DRFOAuth2Handler/*: RequestRetrier*/ {
    func _should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._lock.lock()
        
        guard let url: URL = request.request?.url else {
            completion(false, 0.0)
            return
        }
        
        switch url {
        // TODO: Implement client callbacks
        case self._settings.tokenRequestURL: break
        case self._settings.tokenRefreshURL: break
        case self._settings.tokenRevokeURL: break
        default:
            break
        }
        
        // ???: Should there be checks for more error codes like 429, for example?
        guard let response: HTTPURLResponse = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }
        
        self._requestsToRetry.append(completion)
        self._refreshTokens()
        self._lock.unlock()
    }
}


// MARK: Token Request Implementation
private extension DRFOAuth2Handler {
    func _requestTokens(username: String, password: String) {
        guard !self._isRequesting else { return }
        self._isRequesting = true
        
        let url: URL = self._settings.tokenRequestURL
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
            success: {
                // FIXME: Call Client/s
            }
        )
    }
}


// MARK: Token Refresh Implementation
private extension DRFOAuth2Handler {
    func _refreshTokens() {
        guard !self._isRefreshing else { return }
        self._isRefreshing = true
        
        guard let refreshToken: String = self._credentialStore.refreshToken else {
            self._processRequestsToRetry(shouldRetry: false, clear: true)
            // FIXME: Call Client/s
            return
        }
        
        let url: URL = self._settings.tokenRefreshURL
        let parameters: [String : Any] = [
            _C.JSONKeys.refreshToken: refreshToken,
            _C.JSONKeys.grantType: _C.GrantTypes.refreshToken
        ]
        
        self.__requestAndSaveTokens(
            url: url,
            parameters: parameters,
            updateStatus: { self._isRefreshing = false },
            success: { self._processRequestsToRetry(shouldRetry: true, clear: true) }
        )
    }
    
    private func _processRequestsToRetry(shouldRetry: Bool, clear: Bool) {
        self._requestsToRetry.forEach({ $0(shouldRetry, 0.0) })
        if clear {
            self._requestsToRetry = []
        }
    }
}


// MARK: Common Token Request Functionality
private extension DRFOAuth2Handler {
    func __requestAndSaveTokens(url: URL, parameters: Parameters, updateStatus: @escaping () -> Void, success: @escaping () -> Void) {
        let method: HTTPMethod = .post
        let encoding: ParameterEncoding = URLEncoding.default
        
        let basicAuthHeader: _Header = self._basicAuthHeader()
        let headers: [String : String] = [basicAuthHeader.key : basicAuthHeader.value]
        
        ValidatedJSONRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers).fire(
            via: self._sessionManager,
            onSuccess: { json in
                self._lock.lock()
                
                guard let tokenResponse: _TokenResponse = _TokenResponse(json: json) else {
                    // FIXME: Handle this somehow (call client, log, ?)
                    return
                }
                
                self._credentialStore.updateWith(
                    accessToken: tokenResponse.accessToken,
                    refreshToken: tokenResponse.refreshToken,
                    expiryDate: tokenResponse.expiryDate
                )
                
                updateStatus()
                success()
                
                self._lock.unlock()
            },
            onFailure: { _ in
                // ???: Depending on the reason for the failure, the credentialStore should maybe be cleared here?
                self._lock.lock()
                updateStatus()
                self._lock.unlock()
            }
        )
    }
}


// MARK: Token Revoke Implementation
private extension DRFOAuth2Handler {
    func _revokeTokens() {
        guard let accessToken: String = self._credentialStore.accessToken else { return }
        
        let url: URL = self._settings.tokenRevokeURL
        let method: HTTPMethod = .post
        let parameters: [String : Any] = [_C.JSONKeys.token : accessToken]
        let basicAuthHeader: _Header = self._basicAuthHeader()
        let headers: [String : String] = [basicAuthHeader.key : basicAuthHeader.value]
        
        // ???: How should a failed request be handled here?
        self._sessionManager.request(url, method: method, parameters: parameters, headers: headers)
        
        // ???: I suppose it's cleaner to clear the credentialStore synchronously
        // instead of waiting for the request to receive a response. Is it though?
        self._credentialStore.clear()
    }
}
