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
public struct DRFOAuth2Settings {
    var appSecret: String
    var tokenRequestEndpoint: URL
    var tokenRefreshEndpoint: URL
    var tokenRevokeEndpoint: URL
}


// MARK: - DRFOAuth2Credentials
public struct DRFOAuth2Credentials {
    var accessToken: String
    var refreshToken: String
    var grantType: String
}


// MARK: - DRFOAuth2Handler
public protocol DRFOAuth2Handler: RequestAdapter, RequestRetrier {
    // This SessionManger instance should be exclusively
    // used by this handler and it is not recommended to
    // reconfigure it externally.
    var sessionManager: SessionManager { get }
    var settings: DRFOAuth2Settings { get }
    var credentials: DRFOAuth2Credentials { get set }
}


// MARK: Default Implementations
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
