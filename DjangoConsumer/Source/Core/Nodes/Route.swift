//
//  Route.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: - RouteType
public class RouteType: Equatable {
    // Subclasses
    final public class List: RouteType {}
    final public class Detail: RouteType {}
    
    // Init
    fileprivate init(_ method: ResourceHTTPMethod) { self.method = method }
    
    // Variables
    private(set) var method: ResourceHTTPMethod
    
    // ListRoutes
    static let listGET: List = List(.get)
    static let listPOST: List = List(.post)
    
    // DetailRoutes
    static let detailGET: Detail = Detail(.get)
    static let singlePOST: Detail = Detail(.post)
    static let detailPUT: Detail = Detail(.put)
    static let detailPATCH: Detail = Detail(.patch)
    static let detailDELETE: Detail = Detail(.delete)
    
    // Equatable Implementation
    public static func == (_ lhs: RouteType, _ rhs: RouteType) -> Bool {
        return type(of: lhs) == type(of: rhs) && lhs.method == rhs.method
    }
}


// MARK: - Route
// MARK: Struct Declaration
public struct Route {
    // Private Init
    private init(_ resourceType: MetaResource.Type, _ routeType: RouteType, _ relativePath: String) {
        self.resourceType = resourceType
        self.routeType = routeType
        self.relativeURL = URL(string: relativePath)!
    }
    
    // Public Variables
    public private(set) var resourceType: MetaResource.Type
    public private(set) var routeType: RouteType
    public private(set) var relativeURL: URL
}


// MARK: Protocol Conformances
// MARK: Equatable
extension Route: Equatable {
    public static func ==(_ lhs: Route, _ rhs: Route) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}


// MARK: Hashable
extension Route: Hashable {
    public func hash(into hasher: inout Hasher) {
        [self.resourceType, type(of: self.routeType), self.routeType.method].forEach({ hasher.combine("\($0)") })
    }
}


// MARK: Available Routes
// MARK: GET
public extension Route {
    static func listGET<T>(_ t: T.Type, _ rel: String) -> Route where T: ListGettable {
        return Route(t, .listGET, rel)
    }
    
    static func detailGET<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailGettable {
        return Route(t, .detailGET, rel)
    }
}


// MARK: POST
public extension Route {
    static func listPOST<T>(_ t: T.Type, _ rel: String) -> Route where T: ListPostable {
        return Route(t, .listPOST, rel)
    }
    
    static func singlePOST<T>(_ t: T.Type, _ rel: String) -> Route where T: SinglePostable {
        return Route(t, .singlePOST, rel)
    }
}


// MARK: PUT
//public extension Route {
//    public static func detailPUT<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailPuttable {
//        return Route(t, .detailPUT, rel)
//    }
//}


// MARK: PATCH
//public extension Route {
//    public static func detailPATCH<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailPatchable {
//        return Route(t, .detailPATCH, rel)
//    }
//}


// MARK: DELETE
//public extension Route {
//    public static func detailDELETE<T>(_ t: T.Type, _ rel: String) -> Route where T: DetailDeletable {
//        return Route(t, .detailDELETE, rel)
//    }
//}


// MARK: // Internal
// MARK: Matching function
extension Route {
    static func matches(_ resourceType: MetaResource.Type, _ routeType: RouteType) -> (Route) -> Bool {
        return { return $0.resourceType == resourceType && $0.routeType == routeType }
    }
}
