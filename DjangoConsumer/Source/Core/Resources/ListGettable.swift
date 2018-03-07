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
        let method: HTTPMethod = .get
        let url: URL = node.absoluteListURL(for: self, method: method)
        
        let limit: UInt = limit > 0 ? limit : node.defaultLimit(for: self)
        
        let allFilters: [FilterType] = {
            if addDefaultFilters, let filteredListGettable = self as? FilteredListGettable.Type {
                return filters + node.defaultFilters(for: filteredListGettable)
            } else {
                return filters
            }
        }()

        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        
        func onSuccess(_ json: JSON) {
            let (pagination, objects): (Pagination, [Self]) = node.extractListResponse(for: self, from: json)
            let success: GETObjectListSuccess = GETObjectListSuccess(
                node: node, responsePagination: pagination, offset: offset, limit: limit, filters: allFilters
            )
            self.listGettableClients.forEach({ $0.gotObjects(objects: objects, with: success) })
        }
        
        func onFailure(_ error: Error) {
            let failure: GETObjectListFailure = GETObjectListFailure(
                objectType: self, node: node, error: error, offset: offset, limit: limit, filters: allFilters
            )
            self.listGettableClients.forEach({ $0.failedGettingObjects(with: failure) })
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method, parameters: parameters),
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
