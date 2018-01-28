//
//  DRFListGettable.swift
//  DjangoRFAFInterface
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
public protocol DRFListGettable: DRFMetaResource {
    init(json: JSON)
    static var clients: [DRFListGettableClient] { get set }
    static func get(from node: DRFNode?, offset: UInt, limit: UInt)
}


// MARK: Default Implementations
public extension DRFListGettable {
    static func get(from node: DRFNode? = nil, offset: UInt = 0, limit: UInt = 0) {
        self._get(from: node, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}


// MARK: // Internal
extension DRFListGettable {
    static func get_(from node: DRFNode?, offset: UInt, limit: UInt, filters: [DRFFilter<Any>], addDefaultFilters: Bool) {
        self._get(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
private extension DRFListGettable {
    static func _get(from node: DRFNode?, offset: UInt, limit: UInt, filters: [DRFFilter<Any>], addDefaultFilters: Bool) {
        let node: DRFNode = node ?? self.defaultNode
        let url: URL = node.absoluteListURL(for: self)
        let limit: UInt = limit > 0 ? limit : node.defaultLimit(for: self)
        
        var allFilters: [DRFFilter] = filters
        if addDefaultFilters {
            if let filteredListGettable = self as? DRFFilteredListGettable.Type {
                allFilters += node.defaultFilters(for: filteredListGettable)
            }
        }

        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        ValidatedJSONRequest(url: url, parameters: parameters).fire(
            onSuccess: { result in
                let (pagination, objects): (DRFPagination, [Self]) = node.extractListResponse(for: self, from: result)
                let success: GETObjectListSuccess<Self> = GETObjectListSuccess(
                    node: node, responsePagination: pagination, offset: offset, limit: limit, filters: allFilters
                )
                self.clients.forEach({ $0.gotObjects(objects: objects, with: success) })
            },
            onFailure: { error in
                let failure: GETObjectListFailure<Self> = GETObjectListFailure(
                    objectType: self, node: node, error: error, offset: offset, limit: limit, filters: allFilters
                )
                self.clients.forEach({ $0.failedGettingObjects(with: failure) })
            }
        )
    }
}
