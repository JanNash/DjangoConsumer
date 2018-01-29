//
//  DRFListGettable+OAuth2.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 29.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: DRFNeedsOAuth2
extension DRFListGettable where Self: DRFNeedsOAuth2 {
    static func get(from node: DRFOAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0) {
        self._get(from: node, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}


// MARK: // Internal
// This implementation is needed because DRFFilteredListGettable reuses this function.
// MARK: where Self: DRFNeedsOAuth2
extension DRFListGettable where Self: DRFNeedsOAuth2 {
    static func get_(from node: DRFOAuth2Node?, offset: UInt, limit: UInt, filters: [DRFFilterType], addDefaultFilters: Bool) {
        self._get(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
// FIXME: This is just copied from above to test if the architecture works
// MARK: where Self: DRFNeedsOAuth2
private extension DRFListGettable where Self: DRFNeedsOAuth2 {
    static func _get(from node: DRFOAuth2Node?, offset: UInt, limit: UInt, filters: [DRFFilterType], addDefaultFilters: Bool) {
        let node: DRFOAuth2Node = node ?? self.defaultNode
        let url: URL = node.absoluteListURL(for: self)
        let limit: UInt = limit > 0 ? limit : node.defaultLimit(for: self)
        
        var allFilters: [DRFFilterType] = filters
        if addDefaultFilters {
            if let filteredListGettable = self as? DRFFilteredListGettable.Type {
                allFilters += node.defaultFilters(for: filteredListGettable)
            }
        }
        
        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        ValidatedJSONRequest(url: url, parameters: parameters).fire(
            via: node.sessionManager,
            onSuccess: { result in
                let (pagination, objects): (DRFPagination, [Self]) = node.extractListResponse(for: self, from: result)
                let success: GETObjectListSuccess = GETObjectListSuccess(
                    node: node, responsePagination: pagination, offset: offset, limit: limit, filters: allFilters
                )
                self.clients.forEach({ $0.gotObjects(objects: objects, with: success) })
        },
            onFailure: { error in
                let failure: GETObjectListFailure = GETObjectListFailure(
                    objectType: self, node: node, error: error, offset: offset, limit: limit, filters: allFilters
                )
                self.clients.forEach({ $0.failedGettingObjects(with: failure) })
        }
        )
    }
}
