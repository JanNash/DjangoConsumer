//
//  DRFOAuth2Handler.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: - DRFOAuth2Settings
// MARK: ???: Should this be a protocol, too? Check RFC
public struct DRFOAuth2Settings {
    var appSecret: String
    var tokenRequestEndpoint: URL
    var tokenRefreshEndpoint: URL
    var tokenRevokeEndpoint: URL
}


// MARK: - DRFOAuth2CredentialStore
public protocol DRFOAuth2CredentialStore {
    var username: String { get set }
    var password: String { get set }
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var refreshDate: Date { get set }
}


// MARK: - DRFOAuth2Handler
public protocol DRFOAuth2Handler: RequestAdapter, RequestRetrier {
    init()
    
    // It is recommended to keep use of these two variables exclusive
    // to the implementation of the type conforming to this protocol.
    //
    // Comment: I did not find a proper way yet to enforce this but in Python,
    //          prefixing with _ seems to suffice as well, so... :)
    var _sessionManager: SessionManager { get set }
    var _lock: NSLock { get }
    
    var settings: DRFOAuth2Settings { get set }
    var credentialStore: DRFOAuth2CredentialStore { get set }
}


// MARK: Default Init
extension DRFOAuth2Handler {
    init(settings: DRFOAuth2Settings, credentialStore: DRFOAuth2CredentialStore) {
        self.init()
        self.settings = settings
        self.credentialStore = credentialStore
        
        // Create default sessionManager (this implementation is gratefully copied
        // from SessionManager.swift in Alamofire)
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
    
}


// MARK: // Private
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
//    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
//
//    func _should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
//        lock.lock() ; defer { lock.unlock() }
//
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            requestsToRetry.append(completion)
//
//            if !isRefreshing {
//                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
//                    guard let strongSelf = self else { return }
//
//                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
//
//                    if let accessToken = accessToken, let refreshToken = refreshToken {
//                        strongSelf.accessToken = accessToken
//                        strongSelf.refreshToken = refreshToken
//                    }
//
//                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
//                    strongSelf.requestsToRetry.removeAll()
//                }
//            }
//        } else {
//            completion(false, 0.0)
//        }
//    }
}
