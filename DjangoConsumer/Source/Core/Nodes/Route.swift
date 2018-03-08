//
//  Route.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 08.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
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
    public var routeType: RouteType
    public var method: HTTPMethod
    public var relativeURL: URL
}
