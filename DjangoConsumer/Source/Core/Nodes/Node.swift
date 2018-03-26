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
    // SessionManager
    var sessionManager: SessionManagerType { get }
    
    // Basic Setup
    var baseURL: URL { get }
    
    // Routes
    var routes: [Route] { get }
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    func defaultFilters(for resourceType: FilteredListGettable.Type) -> [FilterType]
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type
    func extractPaginatedGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T])
    
    // Parameter Generation
    func parametersFrom(filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    func parametersFrom(object: ParameterConvertible) -> Parameters
    
    // List POST Request Helpers
    func parametersFrom<C: Collection>(listPostables: C) -> Parameters where C.Element == ListPostable
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T]
    
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
}


// MARK: Default Implementations
// MARK: List GET Request Helpers
public extension Node {
    func defaultFilters(for resourceType: FilteredListGettable.Type) -> [FilterType] {
        return DefaultImplementations._Node_.defaultFilters(node: self, for: resourceType)
    }
    
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type {
        return DefaultImplementations._Node_.paginationType(node: self, for: resourceType)
    }
    
    func extractPaginatedGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return DefaultImplementations._Node_.extractPaginatedGETListResponse(node: self, for: resourceType, from: json)
    }
}


// MARK: Parameter Generation
public extension Node {
    func parametersFrom(filters: [FilterType]) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, offset: offset, limit: limit)
    }
    
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(object: ParameterConvertible) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, object: object)
    }
}


// MARK: List POST Request Helpers
public extension Node {
    func parametersFrom<C: Collection>(listPostables: C) -> Parameters where C.Element == ListPostable {
        return DefaultImplementations._Node_.parametersFrom(node: self, listPostables: listPostables)
    }
    
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations._Node_.extractPOSTListResponse(node: self, for: resourceType, from: json)
    }
}


// MARK: Request URL Helpers
public extension Node {
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return DefaultImplementations._Node_.relativeURL(node: self, for: resourceType, routeType: routeType, method: method)
    }
    
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return DefaultImplementations._Node_.absoluteURL(node: self, for: resourceType, routeType: routeType, method: method)
    }
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL {
        return DefaultImplementations._Node_.relativeURL(node: self, for: resource, method: method)
    }
    
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL {
        return DefaultImplementations._Node_.absoluteURL(node: self, for: resource, method: method)
    }
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations._Node_.relativeGETURL(node: self, for: resourceID)
    }
    
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations._Node_.absoluteGETURL(node: self, for: resourceID)
    }
}


// MARK: - DefaultImplementations._Node_
// MARK: Request/Response Keys
public extension DefaultImplementations._Node_ {
    public struct ListRequestKeys {
        public static let objects: String = "objects"
    }
    
    public struct ListResponseKeys {
        public static let meta: String = "meta"
        public static let results: String = "results"
    }
}


// MARK: List GET Request Helpers
public extension DefaultImplementations._Node_ {
    public static func defaultFilters(node: Node, for resourceType: FilteredListGettable.Type) -> [FilterType] {
        return []
    }
    
    public static func paginationType<T: ListGettable>(node: Node, for resourceType: T.Type) -> Pagination.Type {
        return DefaultPagination.self
    }
    
    public static func extractPaginatedGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return self._extractPaginatedGETListResponse(node: node, for: resourceType, from: json)
    }
}


// MARK: Parameter Generation
public extension DefaultImplementations._Node_ {
    public static func parametersFrom(node: Node, filters: [FilterType]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.stringKey] = $1.value })
    }
    
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(node: node, offset: offset, limit: limit)
    }
    
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return self._parametersFrom(node: node, offset: offset, limit: limit, filters: filters)
    }
    
    public static func parametersFrom(node: Node, object: ParameterConvertible) -> Parameters {
        return object.toParameters()
    }
}


// MARK: List POST Request Helpers
public extension DefaultImplementations._Node_ {
    public static func parametersFrom<C: Collection>(node: Node, listPostables: C) -> Parameters where C.Element == ListPostable {
        return [ListRequestKeys.objects : listPostables.map({ $0.toParameters() })]
    }
    
    public static func extractPOSTListResponse<T: ListPostable>(node: Node, for resourceType: T.Type, from json: JSON) -> [T] {
        return json[ListResponseKeys.results].array!.map(T.init)
    }
}


// MARK: Request URL Helpers
public extension DefaultImplementations._Node_ {
    // MetaResource.Type URLs
    public static func relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return self._relativeURL(node: node, for: resourceType, routeType: routeType, method: method)
    }
    
    public static func absoluteURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return node.baseURL + node.relativeURL(for: resourceType, routeType: routeType, method: method)
    }
    
    // IdentifiableResource URLs
    public static func relativeURL<T: IdentifiableResource>(node: Node, for resource: T, method: ResourceHTTPMethod) -> URL {
        return node.relativeURL(for: T.self, routeType: .detail, method: method) + resource.id
    }
    
    public static func absoluteURL<T: IdentifiableResource>(node: Node, for resource: T, method: ResourceHTTPMethod) -> URL {
        return node.baseURL + node.relativeURL(for: resource, method: method)
    }
    
    // ResourceID URLs
    public static func relativeGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.relativeURL(for: T.self, routeType: .detail, method: .get) + resourceID
    }
    
    public static func absoluteGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.baseURL + node.relativeGETURL(for: resourceID)
    }
}


// MARK: // Private
// MARK: List GET Request Helper Implementations
private extension DefaultImplementations._Node_ {
    static func _extractPaginatedGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType)
        let pagination: Pagination = paginationType.init(json: json[ListResponseKeys.meta])
        let objects: [T] = json[ListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}


// MARK: Parameter Generation Implementations
private extension DefaultImplementations._Node_ {
    static func _parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        var parameters: Parameters = [:]
        let writeToParameters: (String, Any) -> Void = { parameters[$0] = $1 }
        node.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        node.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    static func _parametersFrom(node: Node, offset: UInt, limit: UInt) -> Parameters {
        return [
            DefaultPagination.Keys.offset: offset,
            DefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: Request URL Helper Implementations
private extension DefaultImplementations._Node_ {
    static func _relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        let availableRoutes: [Route] = node.routes.filter(Route.matches(resourceType, routeType, method))
        
        guard availableRoutes.count > 0 else {
            fatalError(
                "[DjangoConsumer.Node] No Route registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType.rawValue)', method: '\(method)'"
            )
        }
        
        guard availableRoutes.count == 1 else {
            fatalError(
                "[DjangoConsumer.Node] Multiple Routes registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType.rawValue)', method: '\(method)'"
            )
        }
        
        return availableRoutes[0].relativeURL
    }
}
