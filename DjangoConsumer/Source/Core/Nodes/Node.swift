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
    
    // Filtering
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType]
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    
    // Parameter Generation
    func parametersFrom(filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, method: ResourceHTTPMethod) -> URL
    
    // ResourceID URLs
    func relativeGETURL<T>(for resourceID: ResourceID<T>) -> URL
    func absoluteGETURL<T>(for resourceID: ResourceID<T>) -> URL
    
    // List Response Helpers
    func paginationType<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: ResourceHTTPMethod) -> Pagination.Type
    func extractListResponse<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: ResourceHTTPMethod, from json: JSON) -> (Pagination, [T])
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
    func parametersFrom(filters: [FilterType]) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, offset: offset, limit: limit)
    }
    
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return DefaultImplementations._Node_.parametersFrom(node: self, offset: offset, limit: limit, filters: filters)
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
    func relativeGETURL<T>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations._Node_.relativeGETURL(node: self, for: resourceID)
    }
    
    func absoluteGETURL<T>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations._Node_.absoluteGETURL(node: self, for: resourceID)
    }
}


// MARK: List Response Helpers
public extension Node {
    func paginationType<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: ResourceHTTPMethod) -> Pagination.Type {
        return DefaultImplementations._Node_.paginationType(node: self, for: resourceType, with: method)
    }
    
    func extractListResponse<T: ListResource & JSONInitializable>(for resourceType: T.Type, with method: ResourceHTTPMethod, from json: JSON) -> (Pagination, [T]) {
        return DefaultImplementations._Node_.extractListResponse(node: self, for: resourceType, with: method, from: json)
    }
}


// MARK: - DefaultImplementations._Node_
// MARK: Parameter Generation
public extension DefaultImplementations._Node_ {
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> Parameters {
        return self._parametersFrom(node: node, offset: offset, limit: limit, filters: filters)
    }
    
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(node: node, offset: offset, limit: limit)
    }
    
    public static func parametersFrom(node: Node, filters: [FilterType]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.stringKey] = $1.value })
    }
}


// MARK: Request URL Helpers
public extension DefaultImplementations._Node_ {
    // MetaResource.Type URLs
    public static func relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return self._relativeURL(node: node, for: resourceType, routeType: routeType, method: method)
    }
    
    public static func absoluteURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeURL(for: resourceType, routeType: routeType, method: method).absoluteString)
    }
    
    // IdentifiableResource URLs
    public static func relativeURL<T: IdentifiableResource>(node: Node, for resource: T, method: ResourceHTTPMethod) -> URL {
        return node.relativeURL(for: T.self, routeType: .detail, method: method).appendingPathComponent(resource.id.string)
    }
    
    public static func absoluteURL<T: IdentifiableResource>(node: Node, for resource: T, method: ResourceHTTPMethod) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeURL(for: resource, method: method).absoluteString)
    }
    
    // ResourceID URLs
    public static func relativeGETURL<T>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.relativeURL(for: T.self, routeType: .detail, method: .get).appendingPathComponent(resourceID.string)
    }
    
    public static func absoluteGETURL<T>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeGETURL(for: resourceID).absoluteString)
    }
}


// MARK: List Response Helpers
public extension DefaultImplementations._Node_ {
    public static func paginationType<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: ResourceHTTPMethod) -> Pagination.Type {
        return DefaultPagination.self
    }
    
    public static func extractListResponse<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: ResourceHTTPMethod, from json: JSON) -> (Pagination, [T]) {
        return self._extractListResponse(node: node, for: resourceType, with: method, from: json)
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
        if let route: Route = self._routeMatching(resourceType: resourceType, routeType: routeType, method: method, in: node) {
            return route.relativeURL
        }
        
        fatalError(
            "[DjangoConsumer.Node] No relative URL registered in '\(node)' for type " +
            "'\(resourceType)', routeType '\(routeType.rawValue)', method: '\(method)'"
        )
    }
    
    // Helper
    static func _routeMatching(resourceType: MetaResource.Type, routeType: RouteType, method: ResourceHTTPMethod, in node: Node) -> Route? {
        return node.routes.first(where: {
            $0.resourceType == resourceType &&
            $0.routeType == routeType &&
            $0.method == method
        })
    }
}


// MARK: List Response Helper Implementations
private extension DefaultImplementations._Node_ {
    static func _extractListResponse<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: ResourceHTTPMethod, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType, with: method)
        let pagination: Pagination = paginationType.init(json: json[DefaultListResponseKeys.meta])
        let objects: [T] = json[DefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}
