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
    static var defaultLimit: UInt { get }
    static func get<T: DRFNode>(from node: T, offset: UInt, limit: UInt)
}


// MARK: Default Implementations
public extension DRFListGettable {
    static func get<T: DRFNode>(from node: T? = nil, offset: UInt = 0, limit: UInt? = nil) {
        self._get(from: node, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}


// MARK: // Internal
extension DRFListGettable {
    static func get_<T: DRFNode>(from node: T?, offset: UInt, limit: UInt?, filters: [T.FilterType], addDefaultFilters: Bool) {
        self._get(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
private extension DRFListGettable {
    static func _get<T: DRFNode>(from node: T?, offset: UInt, limit: UInt?, filters: [T.FilterType], addDefaultFilters: Bool) {
        let node: T = node ?? T.defaultNode(for: self)
        let url: URL = node.absoluteListURL(for: self)
        let limit: UInt = limit ?? node.defaultLimit(for: self)
        
        var allFilters: [T.FilterType] = filters
        if addDefaultFilters {
            if let filteredListGettable = self as? DRFFilteredListGettable.Type {
                allFilters += node.defaultFilters(for: filteredListGettable)
            }
        }

        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: allFilters)
        ValidatedJSONRequest(url: url, parameters: parameters).fire(
            onFailure: { error in
                self.clients.forEach({
                    $0.failedGettingObjects(
                        ofType: Self.self,
                        from: node,
                        error: error,
                        offset: offset,
                        limit: limit,
                        filters: filters
                    )
                })
            },
            onSuccess: { result in
                let (pagination, objects): (DRFPagination, [Self]) = node.extractListResponse(for: self, from: result)
                self.clients.forEach({
                    $0.got(objects: objects, from: node, pagination: pagination, filters: filters)
                })
            }
        )
    }
}
