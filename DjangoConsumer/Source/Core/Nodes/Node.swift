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
    
    // SessionManager
    var sessionManager: SessionManagerType { get }
    
    // Routes
    var routes: [Route] { get }
    
    // Filtering
    func defaultFilters(for objectType: FilteredListGettable.Type) -> [FilterType]
    
    // Parameter Generation
    func parametersFrom(offset: UInt, limit: UInt, filters: [FilterType]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(filters: [FilterType]) -> Parameters
    
    // Request URL Helpers
    func relativeURL(for resourceType: MetaResource.Type, routeType: RouteType, method: HTTPMethod) -> URL
    
    // List GET Request Helpers
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt
    
    // List Response Helpers
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type
    func extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T])
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


// MARK: List Response Helpers
public extension Node {
    func paginationType<T: ListGettable>(for resourceType: T.Type) -> Pagination.Type {
        return DefaultPagination.self
    }
    
    func extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        return self._extractListResponse(for: resourceType, from: json)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementation
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


// MARK: List GET Request and Response Helper Implementations
private extension Node {
    func _extractListResponse<T: ListGettable>(for resourceType: T.Type, from json: JSON) -> (Pagination, [T]) {
        let paginationType: Pagination.Type = self.paginationType(for: resourceType)
        let pagination: Pagination = paginationType.init(json: json[DefaultListResponseKeys.meta])
        let objects: [T] = json[DefaultListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}
