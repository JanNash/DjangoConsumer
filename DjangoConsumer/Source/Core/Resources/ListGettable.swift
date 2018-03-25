//
//  ListGettable.swift
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
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol ListGettable: ListResource, JSONInitializable {
    static var listGettableClients: [ListGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension ListGettable where Self: NeedsNoAuth {
    static func get(from node: Node = Self.defaultNode, offset: UInt = 0, limit: UInt? = nil) {
        DefaultImplementations._ListGettable_.get(
            self, from: node, offset: offset, limit: limit, filters: [], addDefaultFilters: false
        )
    }
}


// MARK: - DefaultImplementations._ListGettable_
public extension DefaultImplementations._ListGettable_ {
    public static func get<T: ListGettable>(_ listGettableType: T.Type, from node: Node, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        self._get(listGettableType, from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
private extension DefaultImplementations._ListGettable_ {
    static func _get<T: ListGettable>(_ l: T.Type, from node: Node, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        let method: ResourceHTTPMethod = .get
        let url: URL = node.absoluteURL(for: T.self, routeType: .list, method: method)
        
        let limit: UInt = limit ?? node.defaultLimit(for: l)
        
        let allFilters: [FilterType] = {
            if addDefaultFilters, let filteredListGettable = T.self as? FilteredListGettable.Type {
                return filters + node.defaultFilters(for: filteredListGettable)
            } else {
                return filters
            }
        }()

        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        
        func onSuccess(_ json: JSON) {
            let (pagination, objects): (Pagination, [T]) = node.extractPaginatedGETListResponse(for: T.self, from: json)
            let success: GETObjectListSuccess = GETObjectListSuccess(
                node: node, responsePagination: pagination, offset: offset, limit: limit, filters: allFilters
            )
            T.listGettableClients.forEach({ $0.gotObjects(objects: objects, with: success) })
        }
        
        func onFailure(_ error: Error) {
            let failure: GETObjectListFailure = GETObjectListFailure(
                objectType: T.self, node: node, error: error, offset: offset, limit: limit, filters: allFilters
            )
            T.listGettableClients.forEach({ $0.failedGettingObjects(with: failure) })
        }
        
        node.sessionManager.fireJSONRequest(
            with: RequestConfiguration(url: url, method: method, parameters: parameters),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
