//
//  ListRequest.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Interface
public extension ValidatedJSONRequest {
    // Typealiases
    typealias SuccessBlock = (JSON) -> Void
    typealias FailureBlock = (Error) -> Void
    
    // Functions
    func fire(via sessionManager: SessionManager, onSuccess: @escaping SuccessBlock, onFailure: @escaping FailureBlock) {
        self._fire(via: sessionManager, onSuccess: onSuccess, onFailure: onFailure)
    }
}

// MARK: Struct Declaration
public struct ValidatedJSONRequest {
    // Init
    init(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
    
    // Variables
    var url: URLConvertible
    var method: HTTPMethod
    var parameters: Parameters
    var encoding: ParameterEncoding
    var headers: HTTPHeaders?
}


// MARK: // Private
// MARK: Implementation
private extension ValidatedJSONRequest {
    func _fire(via sessionManager: SessionManager, onSuccess: @escaping SuccessBlock, onFailure: @escaping FailureBlock) {
        sessionManager.request(self.url, method: self.method, parameters: self.parameters, encoding: self.encoding, headers: self.headers)
            .validate()
            .responseSwiftyJSON {
                switch $0.result {
                case let .success(result):
                    onSuccess(result)
                case let .failure(error):
                    onFailure(error)
                }
            }
    }
}
