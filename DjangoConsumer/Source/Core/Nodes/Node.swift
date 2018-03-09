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


// MARK: DefaultListResponseKeys
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
        return self._parametersFrom(offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit)
    }
    
    func parametersFrom(filters: [FilterType]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.stringKey] = $1.value })
    }
}


// MARK: Request URL Helpers
public extension Node {
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return self._relativeURL(for: resourceType, routeType: routeType, method: method)
    }
    
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return self.baseURL.appendingPathComponent(self.relativeURL(for: resourceType, routeType: routeType, method: method).absoluteString)
    }
    
    // DetailResource URLs
    func absoluteURL<T: DetailResource>(for resource: T, method: HTTPMethod) -> URL {
        return self.baseURL.appendingPathComponent(self.relativeURL(for: resource, method: method).absoluteString)
    }
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL {
        return self.relativeURL(for: T.self, routeType: .detail, method: method).appendingPathComponent(resource.id.string)
    }
    
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: HTTPMethod) -> URL {
        return self.baseURL.appendingPathComponent(self.relativeURL(for: resource, method: method).absoluteString)
    }
    
    // ResourceID URLs
    func absoluteGETURL<T>(for resourceID: ResourceID<T>) -> URL {
        return self.absoluteURL(for: T.self, routeType: .detail, method: .get).appendingPathComponent(resourceID.string)
    }
}


// MARK: List Response Helpers
public extension Node {
    func paginationType<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: HTTPMethod) -> Pagination.Type {
        return DefaultPagination.self
    }
    
    func extractListResponse<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T]) {
        return self._extractListResponse(for: resourceType, with: method, from: json)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementations
private extension Node {
    func _parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        var parameters: Parameters = [:]
        let writeToParameters: (String, Any) -> Void = { parameters[$0] = $1 }
        self.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        self.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    func _parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return [
            DefaultPagination.Keys.offset: offset,
            DefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: Request URL Helper Implementations
private extension Node {
    func _relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        if let route: Route = self._routeMatching(resourceType: resourceType, routeType: routeType, method: method) {
            return route.relativeURL
        }
        
        fatalError(
            "[DjangoConsumer.Node] No relative URL registered in '\(self)' for type " +
            "'\(resourceType)', routeType '\(routeType.rawValue)', method: '\(method)'"
        )
    }
    
    // Helper
    func _routeMatching(resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> Route? {
        return self.routes.first(where: {
            $0.resourceType == resourceType &&
            $0.routeType == routeType &&
            $0.method == method
        })
    }
}


// MARK: List Response Helper Implementations
private extension Node {
    func _extractListResponse<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = self.paginationType(for: resourceType, with: method)
        let pagination: Pagination = paginationType.init(json: json[DefaultListResponseKeys.meta])
        let objects: [T] = json[DefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}
