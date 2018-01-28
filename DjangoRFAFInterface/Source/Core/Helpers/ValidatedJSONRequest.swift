//
//  ListRequest.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
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
    init(url: URL, parameters: Parameters) {
        self.url = url
        self.parameters = parameters
    }
    
    // Variables
    var url: URL
    var parameters: Parameters
}


// MARK: // Private
// MARK: Implementation
private extension ValidatedJSONRequest {
    func _fire(via sessionManager: SessionManager, onSuccess: @escaping SuccessBlock, onFailure: @escaping FailureBlock) {
        sessionManager.request(self.url, parameters: self.parameters)
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
