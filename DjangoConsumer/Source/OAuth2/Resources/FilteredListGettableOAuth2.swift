//
//  FilteredListGettableOAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 29.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: Protocol Declaration
public protocol FilteredListGettableOAuth2: FilteredListGettable, ListGettableOAuth2 {}


// MARK: Default Implementations
public extension FilteredListGettableOAuth2 {
    static func get(from node: OAuth2Node = Self.listGETdefaultNode, offset: UInt = 0, limit: UInt? = nil, filters: [FilterType] = [], addDefaultFilters: Bool = true) {
        DefaultImplementations._FilteredListGettable_.get(
            self, from: node, via: node.oauth2Handler.authenticatedSessionManager, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters
        )
    }
}
