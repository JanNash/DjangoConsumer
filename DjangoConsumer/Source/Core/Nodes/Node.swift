//
//  Node.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
public protocol Node {
    // Basic Setup
    var baseURL: URL { get }
    
    // Routes
    var routes: [Route] { get }
    
    // SessionManager
    var sessionManager: SessionManagerType { get }
    
    // Filtering
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType]
    
    // Parameter Generation
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(filters: [FilterType]) -> Parameters
    
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL
    
    // DetailResource URLs
    func relativeURL<T: DetailResource>(for resource: T, method: HTTPMethod) -> URL
    func absoluteURL<T: DetailResource>(for resource: T, method: HTTPMethod) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL
    
    // ResourceID URLs
    func relativeGETURL<T>(for resourceID: ResourceID<T>) -> URL
    func absoluteGETURL<T>(for resourceID: ResourceID<T>) -> URL
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    
    // List Response Helpers
    func paginationType<T: ListResource>(for resourceType: T.Type, with method: HTTPMethod) -> Pagination.Type
    func extractListResponse<T: ListResource>(for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T])
}


// MARK: - DefaultListResponseKeys
public struct DefaultListResponseKeys {
    public static let meta: String = "meta"
    public static let results: String = "results"
}


// MARK: Default Implementations
// MARK: Filtering
public extension Node {
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType] {
        return []
    }
}


// MARK: Parameter Generation
public extension Node {
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return DefaultNodeImplementations.parametersFrom(node: self, offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return DefaultNodeImplementations.parametersFrom(node: self, offset: offset, limit: limit)
    }
    
    func parametersFrom(filters: [FilterType]) -> Parameters {
        return DefaultNodeImplementations.parametersFrom(node: self, filters: filters)
    }
}


// MARK: Request URL Helpers
public extension Node {
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return DefaultNodeImplementations.relativeURL(node: self, for: resourceType, routeType: routeType, method: method)
    }
    
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return DefaultNodeImplementations.absoluteURL(node: self, for: resourceType, routeType: routeType, method: method)
    }
    
    // DetailResource URLs
    func absoluteURL<T: DetailResource>(for resource: T, method: HTTPMethod) -> URL {
        return DefaultNodeImplementations.absoluteURL(node: self, for: resource, method: method)
    }
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL {
        return DefaultNodeImplementations.relativeURL(node: self, for: resource, method: method)
    }
    
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL {
        return DefaultNodeImplementations.absoluteURL(node: self, for: resource, method: method)
    }
    
    // ResourceID URLs
    func absoluteGETURL<T>(for resourceID: ResourceID<T>) -> URL {
        return DefaultNodeImplementations.absoluteGETURL(node: self, for: resourceID)
    }
}


// MARK: List Response Helpers
public extension Node {
    func paginationType<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: HTTPMethod) -> Pagination.Type {
        return DefaultNodeImplementations.paginationType(node: self, for: resourceType, with: method)
    }
    
    func extractListResponse<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T]) {
        return DefaultNodeImplementations.extractListResponse(node: self, for: resourceType, with: method, from: json)
    }
}
