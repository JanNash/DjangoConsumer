//
//  JSONResponseHandling.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - JSONResponseHandling
public struct JSONResponseHandling {
    // Inits
    public init(onSuccess: @escaping (JSON) -> Void, onFailure: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    // Public Variables
    public var onSuccess: (JSON) -> Void
    public var onFailure: (Error) -> Void
    
    // Handle Response
    func handleResponse(_ response: DataResponse<JSON>) {
        switch response.result {
        case let .success(result):
            self.onSuccess(result)
        case let .failure(error):
            self.onFailure(error)
        }
    }
}
