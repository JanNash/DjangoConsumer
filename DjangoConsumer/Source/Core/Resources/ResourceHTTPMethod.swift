//
//  ResourceHTTPMethod.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
public enum ResourceHTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    
    public static var all: [ResourceHTTPMethod] = [.get, .head, .post, .put, .patch, .delete]
    public func toHTTPMethod() -> HTTPMethod { return HTTPMethod(rawValue: self.rawValue)! }
}
