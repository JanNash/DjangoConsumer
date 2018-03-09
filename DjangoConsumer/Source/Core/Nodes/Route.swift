//
//  Route.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 08.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: - RouteType
public enum RouteType: String {
    case detail = "detail"
    case list = "list"
}


// MARK: - Route
// MARK: Struct Declaration
public struct Route {
    // Init
    public init(_ resourceType: MetaResource.Type, _ routeType: RouteType, _ method: HTTPMethod, _ relativePath: String) {
        self.resourceType = resourceType
        self.routeType = routeType
        self.method = method
        self.relativeURL = URL(string: relativePath)!
    }
    
    // Public Variables
    public private(set) var resourceType: MetaResource.Type
    public private(set) var routeType: RouteType
    public private(set) var method: HTTPMethod
    public private(set) var relativeURL: URL
}
