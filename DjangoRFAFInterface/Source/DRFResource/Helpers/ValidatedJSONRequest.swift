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
    typealias FailureBlock = (Error) -> Void
    typealias SuccessBlock = (JSON) -> Void
    
    // Functions
    func fire(onFailure: @escaping FailureBlock, onSuccess: @escaping SuccessBlock) {
        self._fire(onFailure: onFailure, onSuccess: onSuccess)
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
    func _fire(onFailure: @escaping FailureBlock, onSuccess: @escaping SuccessBlock) {
        Alamofire.request(self.url, parameters: self.parameters)
            .validate()
            .responseSwiftyJSON {
                switch $0.result {
                case let .failure(error):
                    onFailure(error)
                case let .success(result):
                    onSuccess(result)
                }
            }
    }
}
