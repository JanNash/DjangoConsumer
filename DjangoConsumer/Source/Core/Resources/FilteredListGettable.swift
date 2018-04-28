//
//  FilteredListGettableNoAuth.swift
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
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - FilteredListGettable
// MARK: Protocol Declaration
public protocol FilteredListGettable: ListGettable {}


// MARK: Protocol Declaration
// MARK: - FilteredListGettableNoAuth
public protocol FilteredListGettableNoAuth: FilteredListGettable, ListGettableNoAuth {}


// MARK: Default Implementations
public extension FilteredListGettableNoAuth {
    static func get(from node: NoAuthNode = Self.defaultNoAuthNode, offset: UInt = 0, limit: UInt? = nil, filters: [FilterType] = [], addDefaultFilters: Bool = true) {
        DefaultImplementations.FilteredListGettable.get(
            self, from: node, via: node.sessionManagerNoAuth, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters
        )
    }
}


// MARK: - DefaultImplementations.FilteredListGettable
public extension DefaultImplementations.FilteredListGettable {
    public static func get<T: FilteredListGettable>(_ filteredListGettableType: T.Type, from node: Node, via sessionManager: SessionManagerType, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        self._get(filteredListGettableType, from: node, via: sessionManager, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
private extension DefaultImplementations.FilteredListGettable {
    static func _get<T: FilteredListGettable>(_ f: T.Type, from node: Node, via sessionManager: SessionManagerType, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        let allFilters: [FilterType] = addDefaultFilters ? (node.defaultFilters(for: f) + filters) : filters
        DefaultImplementations.ListGettable.get(f, from: node, via: sessionManager, offset: offset, limit: limit, filters: allFilters)
    }
}
