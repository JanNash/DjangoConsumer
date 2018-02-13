//
//  ListGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol ListGettable: ListResource {
    init(json: JSON)
    static var listGettableClients: [ListGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension ListGettable where Self: NeedsNoAuth {
    static func get(from node: Node? = nil, offset: UInt = 0, limit: UInt = 0) {
        self._get(from: node ?? self.defaultNode, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}


// MARK: // Internal
// MARK: Shared GET function
extension ListGettable {
    static func get_(from node: Node, offset: UInt, limit: UInt, filters: [FilterType], addDefaultFilters: Bool) {
        self._get(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
// MARK: Shared GET function Implementation
private extension ListGettable {
    static func _get(from node: Node, offset: UInt, limit: UInt, filters: [FilterType], addDefaultFilters: Bool) {
        let url: URL = node.absoluteListURL(for: self)
        let limit: UInt = limit > 0 ? limit : node.defaultLimit(for: self)
        
        var allFilters: [FilterType] = filters
        if addDefaultFilters {
            if let filteredListGettable = self as? FilteredListGettable.Type {
                allFilters += node.defaultFilters(for: filteredListGettable)
            }
        }

        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        ValidatedJSONRequest(url: url, parameters: parameters).fire(
            via: node.sessionManager,
            onSuccess: { result in
                let (pagination, objects): (Pagination, [Self]) = node.extractListResponse(for: self, from: result)
                let success: GETObjectListSuccess = GETObjectListSuccess(
                    node: node, responsePagination: pagination, offset: offset, limit: limit, filters: allFilters
                )
                self.listGettableClients.forEach({ $0.gotObjects(objects: objects, with: success) })
            },
            onFailure: { error in
                let failure: GETObjectListFailure = GETObjectListFailure(
                    objectType: self, node: node, error: error, offset: offset, limit: limit, filters: allFilters
                )
                self.listGettableClients.forEach({ $0.failedGettingObjects(with: failure) })
            }
        )
    }
}
