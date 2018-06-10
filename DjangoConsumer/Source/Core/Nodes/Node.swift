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

import Alamofire
import SwiftyJSON


// MARK: // Public
public protocol Node {
    // Basic Setup
    var baseURL: URL { get }
    
    // Routes
    var routes: [Route] { get }
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    func defaultFilters(for resourceType: FilteredListGettable.Type) -> [FilterType]
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type
    
    // URL Parameter Generation
    func parametersFrom(filters: [FilterType]) -> JSONDict
    func parametersFrom(offset: UInt, limit: UInt) -> JSONDict
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> JSONDict
    
    // Request Payload Generation
    func payloadFrom(object: RequestPayloadConvertible, method: ResourceHTTPMethod) -> RequestPayload
    func payloadFrom<C: Collection, T: ListPostable>(listPostables: C) -> RequestPayload where C.Element == T
    
    // URLs
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL
    func absoluteURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL
    
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
        return DefaultImplementations.Node.defaultFilters(node: self, for: resourceType)
    }
    
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type {
        return DefaultImplementations.Node.paginationType(node: self, for: resourceType)
    }
}


// MARK: URL Parameter Generation
public extension Node {
    func parametersFrom(filters: [FilterType]) -> JSONDict {
        return DefaultImplementations.Node.parametersFrom(node: self, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> JSONDict {
        return DefaultImplementations.Node.parametersFrom(node: self, offset: offset, limit: limit)
    }
    
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType] = []) -> JSONDict {
        return DefaultImplementations.Node.parametersFrom(node: self, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: Request Payload Generation
public extension Node {
    func payloadFrom(object: RequestPayloadConvertible, method: ResourceHTTPMethod) -> RequestPayload {
        return DefaultImplementations.Node.payloadFrom(node: self, object: object, method: method)
    }
    
    func payloadFrom<C: Collection, T: ListPostable>(listPostables: C) -> RequestPayload where C.Element == T {
        return DefaultImplementations.Node.payloadFrom(node: self, listPostables: listPostables)
    }
}


// MARK: Request URL Helpers
public extension Node {
    // MetaResource.Type URLs
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return DefaultImplementations.Node.relativeURL(node: self, for: resourceType, routeType: routeType)
    }
    
    func absoluteURL(for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return DefaultImplementations.Node.absoluteURL(node: self, for: resourceType, routeType: routeType)
    }
    
    // IdentifiableResource URLs
    func relativeURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try DefaultImplementations.Node.relativeURL(node: self, for: resource, routeType: routeType)
    }
    
    func absoluteURL<T: IdentifiableResource>(for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try DefaultImplementations.Node.absoluteURL(node: self, for: resource, routeType: routeType)
    }
    
    // ResourceID URLs
    func relativeGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations.Node.relativeGETURL(node: self, for: resourceID)
    }
    
    func absoluteGETURL<T: DetailGettable>(for resourceID: ResourceID<T>) -> URL {
        return DefaultImplementations.Node.absoluteGETURL(node: self, for: resourceID)
    }
}


// MARK: Detail Response Extraction Helpers
public extension Node {
    func extractSingleObject<T: JSONInitializable>(for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return DefaultImplementations.Node.extractSingleObject(node: self, for: resourceType, method: method, from: json)
    }
}


// MARK: List Response Extraction Helpers
public extension Node {
    func extractGETListResponsePagination(with paginationType: Pagination.Type, from json: JSON) -> Pagination {
        return DefaultImplementations.Node.extractGETListResponsePagination(node: self, with: paginationType, from: json)
    }
    
    func extractGETListResponseObjects<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations.Node.extractGETListResponseObjects(node: self, for: T.self, from: json)
    }
    
    func extractGETListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return DefaultImplementations.Node.extractGETListResponse(node: self, for: resourceType, from: json)
    }
    
    func extractPOSTListResponse<T: ListPostable>(for resourceType: T.Type, from json: JSON) -> [T] {
        return DefaultImplementations.Node.extractPOSTListResponse(node: self, for: resourceType, from: json)
    }
}


// MARK: - DefaultImplementations.Node
// MARK: Request/Response Keys
public extension DefaultImplementations.Node {
    public enum ListRequestKeys {
        public static let objects: String = "objects"
    }
    
    public enum ListResponseKeys {
        public static let meta: String = "meta"
        public static let results: String = "results"
    }
}


// MARK: List GET Request Helpers
public extension DefaultImplementations.Node {
    public static func defaultFilters(node: Node, for resourceType: FilteredListGettable.Type) -> [FilterType] {
        return []
    }
    
    public static func paginationType<T: ListGettable>(node: Node, for resourceType: T.Type) -> Pagination.Type {
        return DefaultPagination.self
    }
}


// MARK: URL Parameter Generation
public extension DefaultImplementations.Node {
    public static func parametersFrom(node: Node, filters: [FilterType]) -> JSONDict {
        return JSONDict(filters.mapToDict({ ($0.stringKey, $0.value) }))
    }
    
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt) -> JSONDict {
        return self._parametersFrom(node: node, offset: offset, limit: limit)
    }
    
    public static func parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> JSONDict {
        return self._parametersFrom(node: node, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: Request Payload Generation
public extension DefaultImplementations.Node {
    class DefaultMultipartEncoding: MultipartEncoding {}
    
    public static func payloadFrom(node: Node, object: RequestPayloadConvertible, method: ResourceHTTPMethod) -> RequestPayload {
        return object.toPayload(for: method)
    }
    
    public static func payloadFrom<C: Collection, T: ListPostable>(node: Node, listPostables: C) -> RequestPayload where C.Element == T {
        // For now, a request will always be sent as multipart if at least one multipart payload was found.
        // This might induce some overhead, but there would be a way: see essay below :D
        
        // !!!: This function would be the starting point for possibly splitting into two requests
        // One could contain everything that's JSONPayloadConvertible, the other everythin that needs
        // to be sent via multipart. Since the objects can decide at runtime what kind of payload
        // they'll be converted to, it's possible that a list of those objects contains some that need
        // to send multipart data along and some that just contain JSON. An example (of which I'm not
        // sure that it stands true) is that if you send a list of objects that have a variable that's
        // an image, but that variable is optional, it could be possible that some of the objects have
        // an image assigned and some don't. Those that don't could simply send jsonPayload containing
        // 'null' as value for the key of the image. This could make it possible to have guaranteed
        // atomic per-object POSTS (since an object will always be sent as one request, either
        // multipart or json) but to be able to optimize request sizes (and thus durations), since
        // multipart has quite some overhead (see boundary and ContentDisposition) when sending single
        // JSON values, so it might always be preferable to send json, unless multipart is necessary.
        //   Splitting the request into one multipart and one json request has the possible drawback
        // that a list post can not be guaranteed to be atomic, since there will be two lists of
        // objects sent in separate requests. A setting could be added to the node for that, or we
        // could pass in a parameter in DefaultImplementations.ListPostable.post(self, to: node).
        // What a novel this has gotten... 🤩 (Is your project commented? - Yeah, I got over 18
        // lines of comments...)
        
        return self._payloadFrom(node: node, listPostables: listPostables)
    }
}


// MARK: Request URL Helpers
public extension DefaultImplementations.Node {
    // MetaResource.Type URLs
    public static func relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return self._relativeURL(node: node, for: resourceType, routeType: routeType)
    }
    
    public static func absoluteURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        return node.baseURL + node.relativeURL(for: resourceType, routeType: routeType)
    }
    
    // IdentifiableResource URLs
    public static func relativeURL<T: IdentifiableResource>(node: Node, for resource: T, routeType: RouteType.Detail) throws -> URL {
        guard let resourceID: ResourceID<T> = resource.id else { throw IdentifiableResourceError.hasNoID }
        return node.relativeURL(for: T.self, routeType: routeType) + resourceID
    }
    
    public static func absoluteURL<T: IdentifiableResource>(node: Node, for resource: T, routeType: RouteType.Detail) throws -> URL {
        return try node.baseURL + node.relativeURL(for: resource, routeType: routeType)
    }
    
    // ResourceID URLs
    public static func relativeGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.relativeURL(for: T.self, routeType: .detailGET) + resourceID
    }
    
    public static func absoluteGETURL<T: DetailGettable>(node: Node, for resourceID: ResourceID<T>) -> URL {
        return node.baseURL + node.relativeGETURL(for: resourceID)
    }
}


// MARK: Detail Response Extraction Helpers
public extension DefaultImplementations.Node {
    public static func extractSingleObject<T: JSONInitializable>(node: Node, for resourceType: T.Type, method: ResourceHTTPMethod, from json: JSON) -> T {
        return T(json: json)
    }
}


// MARK: List Response Extraction Helpers
public extension DefaultImplementations.Node {
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
// MARK: URL Parameter Generation Implementations
private extension DefaultImplementations.Node {
    static func _parametersFrom(node: Node, offset: UInt, limit: UInt, filters: [FilterType] = []) -> JSONDict {
        var parameters: [String: JSONValueConvertible] = [:]
        let writeToParameters: (String, JSONValueConvertible) -> Void = { parameters[$0] = $1 }
        node.parametersFrom(offset: offset, limit: limit).dict.forEach(writeToParameters)
        node.parametersFrom(filters: filters).dict.forEach(writeToParameters)
        return JSONDict(parameters)
    }
    
    static func _parametersFrom(node: Node, offset: UInt, limit: UInt) -> JSONDict {
        return [
            DefaultPagination.Keys.offset: offset,
            DefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: Request Payload Generation Implementations
private extension DefaultImplementations.Node {
    static func _payloadFrom<C: Collection, T: ListPostable>(node: Node, listPostables: C) -> RequestPayload where C.Element == T {
        var jsonDicts: [JSONDict] = []
        var multipartDicts: [MultipartDict] = []
        
        let count: Int = listPostables.count
        jsonDicts.reserveCapacity(count)
        multipartDicts.reserveCapacity(count)
        
        listPostables.forEach({
            switch $0.toPayload(for: .post) {
            case .json(let dict):
                jsonDicts.append(dict)
                multipartDicts.append(MultipartDict(dict.dict))
            case .multipart(let dict):
                multipartDicts.append(dict)
            }
        })
        
        if multipartDicts.isEmpty {
            return .json([ListRequestKeys.objects: jsonDicts])
        }
        
        return .multipart([ListRequestKeys.objects: multipartDicts])
    }
}


// MARK: Request URL Helper Implementations
private extension DefaultImplementations.Node {
    static func _relativeURL(node: Node, for resourceType: MetaResource.Type, routeType: RouteType) -> URL {
        let availableRoutes: [Route] = node.routes.filter(Route.matches(resourceType, routeType))
        
        guard availableRoutes.count > 0 else {
            fatalError(
                "[DjangoConsumer.Node] No Route registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType)'"
            )
        }
        
        guard availableRoutes.count == 1 else {
            fatalError(
                "[DjangoConsumer.Node] Multiple Routes registered in '\(node)' for type " +
                "'\(resourceType)', routeType '\(routeType)'"
            )
        }
        
        return availableRoutes[0].relativeURL
    }
}


// MARK: List Response Extraction Helper Implementations
private extension DefaultImplementations.Node {
    static func _extractGETListResponse<T: ListGettable>(node: Node, for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = node.paginationType(for: resourceType)
        let pagination: Pagination = node.extractGETListResponsePagination(with: paginationType, from: json)
        let objects: [T] = node.extractGETListResponseObjects(for: T.self, from: json)
        return (pagination, objects)
    }
}
