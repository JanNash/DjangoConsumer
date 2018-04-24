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
    
    // Parameter Generation
    func parametersFrom(filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    func parametersFrom(object: ParameterConvertible, method: ResourceHTTPMethod) -> Parameters
    func parametersFrom<C: Collection, T: ListPostable>(listPostables: C) -> Parameters where C.Element == T
    
    // URLs
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL
    
    // Response Extraction
    // Detail Response Extraction Helpers
    func extractSingleObject<T: JSONInitializable>(for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T
    
    // List Response Extraction Helpers
    func extractGETListResponsePagination(with paginationType: Pagination.Type, from json: JSON) -> Pagination
    func extractGETListResponseObjects<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> [T]
    func extractGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T])
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T]
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
    
    func parametersFrom(object: ParameterConvertible, method: ResourceHTTPMethod) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, object: object, method: method)
    }
    
    func parametersFrom<C: Collection, T: ListPostable>(listPostables: C) -> Parameters where C.Element == T {
        return DefaultImplementations._Node_.parametersFrom(node: self, listPostables: listPostables)
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


// MARK: Detail Response Extraction Helpers
public extension Node {
    func extractSingleObject<T: JSONInitializable>(for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return DefaultImplementations._Node_.extractSingleObject(node: self, for: resourceType, method: method, from: json)
    }
}


// MARK: List Response Extraction Helpers
public extension Node {
    func extractGETListResponsePagination(with paginationType: Pagination.Type, from json: JSON) -> Pagination {
        return DefaultImplementations._Node_.extractGETListResponsePagination(node: self, with: paginationType, from: json)
    }
    
    func extractGETListResponseObjects<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations._Node_.extractGETListResponseObjects(node: self, for: T.self, from: json)
    }
    
    func extractGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return DefaultImplementations._Node_.extractGETListResponse(node: self, for: resourceType, from: json)
    }
    
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations._Node_.extractPOSTListResponse(node: self, for: resourceType, from: json)
    }
}


// MARK: - DefaultImplementations._Node_
// MARK: Request/Response Keys
public extension DefaultImplementations._Node_ {
    public enum ListRequestKeys {
        public static let objects: String = "objects"
    }
    
    public enum ListResponseKeys {
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
    
    public static func parametersFrom(node: Node, object: ParameterConvertible, method: ResourceHTTPMethod) -> Parameters {
        return object.toParameters(for: method)
    }
    
    public static func parametersFrom<C: Collection, T: ListPostable>(node: Node, listPostables: C) -> Parameters where C.Element == T {
        return [ListRequestKeys.objects : listPostables.map({ $0.toParameters(for: .post) })]
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


// MARK: Detail Response Extraction Helpers
public extension DefaultImplementations._Node_ {
    public static func extractSingleObject<T: JSONInitializable>(node: Node, for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return T(json: json)
    }
}


// MARK: List Response Extraction Helpers
public extension DefaultImplementations._Node_ {
    public static func extractGETListResponsePagination(node: Node, with paginationType: Pagination.Type, from json: JSON) -> Pagination {
        return paginationType.init(json: json[ListResponseKeys.meta])
    }
    
    public static func extractGETListResponseObjects<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> [T] {
        return json[ListResponseKeys.results].array!.map(T.init)
    }
    
    public static func extractGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return self._extractGETListResponse(node: node, for: resourceType, from: json)
    }
        
    public static func extractPOSTListResponse<T: ListPostable>(node: Node, for resourceType: T.Type, from json: JSON) -> [T] {
        return json[ListResponseKeys.results].array!.map(T.init)
    }
}


// MARK: // Private
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


// MARK: List Response Extraction Helper Implementations
private extension DefaultImplementations._Node_ {
    static func _extractGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType)
        let pagination: Pagination = node.extractGETListResponsePagination(with: paginationType, from: json)
        let objects: [T] = node.extractGETListResponseObjects(for: T.self, from: json)
        return (pagination, objects)
    }
}
