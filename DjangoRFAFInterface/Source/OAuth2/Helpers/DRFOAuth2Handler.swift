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
    var expiryDate: Date { get set }
}


// MARK: - DRFOAuth2Handler
public protocol DRFOAuth2Handler: class, RequestAdapter, RequestRetrier {
    init()
    
    // It is recommended to keep use of these two variables exclusive
    // to the implementation of the type conforming to this protocol.
    //
    // Comment: I did not find a proper way yet to enforce this but in Python,
    //          prefixing with _ seems to suffice as well, so... :)
    var _sessionManager: SessionManager { get set }
    var _requestsToRetry: [RequestRetryCompletion] { get set }
    var _lock: NSLock { get }
    var _isRefreshing: Bool { get set }
    
    var settings: DRFOAuth2Settings { get set }
    var credentialStore: DRFOAuth2CredentialStore { get set }
}


// MARK: Default Init
extension DRFOAuth2Handler {
    init(settings: DRFOAuth2Settings, credentialStore: DRFOAuth2CredentialStore) {
        self.init()
        self.settings = settings
        self.credentialStore = credentialStore
        
        // Create default sessionManager
        // (this implementation is gratefully copied from SessionManager.swift in Alamofire)
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        self._sessionManager = SessionManager(configuration: configuration)
    }
}


// MARK: RequestAdapter
extension DRFOAuth2Handler/*: RequestAdapter*/ {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return try self._adapt(urlRequest)
    }
}


// MARK: RequestRetrier
extension DRFOAuth2Handler/*: RequestRetrier*/ {
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._should(manager, retry: request, with: error, completion: completion)
    }
}


// MARK: // Private
// MARK: - _RefreshResponse
private struct _RefreshResponse {
    init?(json: JSON) {
        // FIXME: Put these literal strings into constants
        guard let accessToken: String = json["access_token"].string else { return nil }
        guard let refreshToken: String = json["refresh_token"].string else { return nil }
        guard let expiresIn: TimeInterval = json["expires_in"].double else { return nil }
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiryDate = Date().addingTimeInterval(expiresIn)
    }
    
    var accessToken: String
    var refreshToken: String
    var expiryDate: Date
}


// MARK: - DRFOAuth2Handler
// MARK: Implementations
// MARK: RequestAdapter
private extension DRFOAuth2Handler/*: RequestAdapter*/ {
    func _adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        // This implementation is incomplete, it should check for request urls
        // in order to correctly compute which headers to add, for example:
        // - "Basic" + self.settings.appSecret
        // - "Bearer" + self.credentialStore.accessToken
//        var urlRequest: URLRequest = urlRequest
//        urlRequest.setValue("Bearer " + self.accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}


// MARK: RequestRetrier
private extension DRFOAuth2Handler/*: RequestRetrier*/ {
    // Helper Typealias
    private typealias _RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    // Implementation
    func _should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self._lock.lock() ; defer { self._lock.unlock() }

        guard let response: HTTPURLResponse = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }
        
        self._requestsToRetry.append(completion)
        
        guard !_isRefreshing else { return }
        self._isRefreshing = true
        
        let url: URL = self.settings.tokenRefreshURL
        let encoding: ParameterEncoding = JSONEncoding.default
        
        let parameters: [String: Any] = [
            "access_token": self.credentialStore.accessToken,
            "refresh_token": self.credentialStore.refreshToken,
            "grant_type": "refresh_token"
        ]
        
        ValidatedJSONRequest(url: url, method: .post, parameters: parameters, encoding: encoding).fire(
            via: self._sessionManager,
            onSuccess: { json in
                self._lock.lock() ; defer { self._isRefreshing = false ; self._lock.unlock() }
                guard let refreshResponse: _RefreshResponse = _RefreshResponse(json: json) else {
                    return
                }
                
                self.credentialStore.accessToken = refreshResponse.accessToken
                self.credentialStore.refreshToken = refreshResponse.refreshToken
                self.credentialStore.expiryDate = refreshResponse.expiryDate
            },
            onFailure: { error in
                self._lock.lock() ; defer { self._isRefreshing = false ; self._lock.unlock() }
                
            }
        )
    }
}
