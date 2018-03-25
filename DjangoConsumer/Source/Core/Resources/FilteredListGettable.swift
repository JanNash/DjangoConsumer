//
//  FilteredListGettable.swift
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
public protocol FilteredListGettable: ListGettable {}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension FilteredListGettable where Self: NeedsNoAuth {
    static func get(from node: Node = Self.defaultNode, offset: UInt = 0, limit: UInt? = nil, filters: [FilterType] = [], addDefaultFilters: Bool = true) {
        DefaultImplementations._FilteredListGettable_.get(
            self, from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters
        )
    }
}


// MARK: - DefaultImplementations._FilteredListGettable_
public extension DefaultImplementations._FilteredListGettable_ {
    public static func get<T: FilteredListGettable>(_ filteredListGettableType: T.Type, from node: Node, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        self._get(filteredListGettableType, from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: // Private
private extension DefaultImplementations._FilteredListGettable_ {
    static func _get<T: FilteredListGettable>(_ f: T.Type, from node: Node, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool) {
        DefaultImplementations._ListGettable_.get(f, from: node, offset: offset, limit: limit, filters: filters)
    }
}
