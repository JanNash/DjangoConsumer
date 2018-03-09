//
//  DefaultNodeImplementations.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 09.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Struct Declaration
public struct DefaultNodeImplementations {
    // Inside the implementations, 'node' is always used instead of 'self'.
}


// MARK: Parameter Generation
public extension DefaultNodeImplementations {
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
public extension DefaultNodeImplementations {
    // MetaResource.Type URLs
    public static func relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return self._relativeURL(node: node, for: resourceType, routeType: routeType, method: method)
    }
    
    public static func absoluteURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeURL(for: resourceType, routeType: routeType, method: method).absoluteString)
    }
    
    // DetailResource URLs
    public static func absoluteURL<T: DetailResource>(node: Node, for resource: T, method: HTTPMethod) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeURL(for: resource, method: method).absoluteString)
    }
    
    // IdentifiableResource URLs
    public static func relativeURL<T: IdentifiableResource>(node: Node, for resource: T, method: HTTPMethod) -> URL {
        return node.relativeURL(for: T.self, routeType: .detail, method: method).appendingPathComponent(resource.id.string)
    }
    
    public static func absoluteURL<T: IdentifiableResource>(node: Node, for resource: T, method: HTTPMethod) -> URL {
        return node.baseURL.appendingPathComponent(node.relativeURL(for: resource, method: method).absoluteString)
    }
    
    // ResourceID URLs
    public static func absoluteGETURL<T>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.absoluteURL(for: T.self, routeType: .detail, method: .get).appendingPathComponent(resourceID.string)
    }
}


// MARK: List Response Helpers
public extension DefaultNodeImplementations {
    public static func paginationType<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: HTTPMethod) -> Pagination.Type {
        return DefaultPagination.self
    }
    
    public static func extractListResponse<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T]) {
        return self._extractListResponse(node: node, for: resourceType, with: method, from: json)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementations
private extension DefaultNodeImplementations {
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
private extension DefaultNodeImplementations {
    static func _relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL {
        if let route: Route = self._routeMatching(resourceType: resourceType, routeType: routeType, method: method, in: node) {
            return route.relativeURL
        }
        
        fatalError(
            "[DjangoConsumer.Node] No relative URL registered in '\(node)' for type " +
            "'\(resourceType)', routeType '\(routeType.rawValue)', method: '\(method)'"
        )
    }
    
    // Helper
    static func _routeMatching(resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod, in node: Node) -> Route? {
        return node.routes.first(where: {
            $0.resourceType == resourceType &&
                $0.routeType == routeType &&
                $0.method == method
        })
    }
}


// MARK: List Response Helper Implementations
private extension DefaultNodeImplementations {
    static func _extractListResponse<T: ListResource & JSONInitializable>(node: Node, for resourceType: T.Type, with method: HTTPMethod, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType, with: method)
        let pagination: Pagination = paginationType.init(json: json[DefaultListResponseKeys.meta])
        let objects: [T] = json[DefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}
