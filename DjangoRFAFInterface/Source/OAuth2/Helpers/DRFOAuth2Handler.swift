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
    var appSecret: String
    var tokenRequestURL: URL
    var tokenRefreshURL: URL
    var tokenRevokeURL: URL
}


// MARK: - DRFOAuth2CredentialStore
public protocol DRFOAuth2CredentialStore {
    var username: String { get set }
    var password: String { get set }
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var expiryDate: Date { get set } // ???: Should this be optional?
    mutating func refreshWith(accessToken: String, refreshToken: String, expiryDate: Date)
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
    
    
    // Overridables
    open func refreshTokens() {
        self._refreshTokens()
    }
    
    // RequestAdapter
    open func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return self._addBearerAuthorizationHeader(to: urlRequest)
    }
    
    // RequestRetrier
    open func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._should(manager, retry: request, with: error, completion: completion)
    }
}


// MARK: // Private
// MARK: - _WrappedRequestRetrier
// This wrapper class is needed because a DRFOAuth2Handler assigns itself as the retrier
// for its own sessionManager. Without the wrapper, this would create a strong reference cycle.
class _Weak: RequestRetrier {
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


// MARK: Add Authorization Headers
private extension DRFOAuth2Handler {
    func _addBearerAuthorizationHeader(to urlRequest: URLRequest) -> URLRequest {
        var urlRequest: URLRequest = urlRequest
        urlRequest.setValue(
            DRFOAuth2Constants.HeaderValues.bearer(self._credentialStore.accessToken),
            forHTTPHeaderField: DRFOAuth2Constants.HeaderFields.authorization
        )
        return urlRequest
    }
}


// MARK: RequestRetrier
private extension DRFOAuth2Handler/*: RequestRetrier*/ {
    private struct _RefreshResponse {
        init?(json: JSON) {
            guard let accessToken: String = json[DRFOAuth2Constants.JSONKeys.accessToken].string else { return nil }
            guard let refreshToken: String = json[DRFOAuth2Constants.JSONKeys.refreshToken].string else { return nil }
            guard let expiresIn: TimeInterval = json[DRFOAuth2Constants.JSONKeys.expiresIn].double else { return nil }
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            // ???: Should a tolerance be subtracted from expiresIn to account for request duration?
            self.expiryDate = Date().addingTimeInterval(expiresIn)
        }
        
        var accessToken: String
        var refreshToken: String
        var expiryDate: Date
    }
    
    // Implementation
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


// MARK: Token Refresh Implementation
private extension DRFOAuth2Handler {
    func _refreshTokens() {
        guard !self._isRefreshing else { return }
        self._isRefreshing = true
        
        let url: URL = self._settings.tokenRefreshURL
        let encoding: ParameterEncoding = JSONEncoding.default
        
        let parameters: [String : Any] = [
            DRFOAuth2Constants.JSONKeys.accessToken: self._credentialStore.accessToken,
            DRFOAuth2Constants.JSONKeys.refreshToken: self._credentialStore.refreshToken,
            DRFOAuth2Constants.JSONKeys.grantType: DRFOAuth2Constants.GrantTypes.refreshToken
        ]
        
        let headers: [String : String] = [
            DRFOAuth2Constants.HeaderFields.authorization: DRFOAuth2Constants.HeaderValues.basic(self._settings.appSecret)
        ]
        
        ValidatedJSONRequest(url: url, method: .post, parameters: parameters, encoding: encoding, headers: headers).fire(
            via: self._sessionManager,
            onSuccess: { json in
                self._lock.lock() ; defer { self._isRefreshing = false ; self._lock.unlock() }
                guard let refreshResponse: _RefreshResponse = _RefreshResponse(json: json) else {
                    return
                }
                
                self._credentialStore.refreshWith(
                    accessToken: refreshResponse.accessToken,
                    refreshToken: refreshResponse.refreshToken,
                    expiryDate: refreshResponse.expiryDate
                )
                
                self._requestsToRetry.forEach({ $0(true, 0.0) })
                self._requestsToRetry = []
            },
            onFailure: { error in
                self._lock.lock() ; defer { self._isRefreshing = false ; self._lock.unlock() }
            }
        )
    }
}
