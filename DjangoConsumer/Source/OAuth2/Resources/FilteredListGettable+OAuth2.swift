//
//  FilteredListGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 29.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: where Self: NeedsOAuth2
public extension FilteredListGettable where Self: NeedsOAuth2 {
    static func get(from node: OAuth2Node = Self.defaultNode, offset: UInt = 0, limit: UInt? = nil, filters: [FilterType] = [], addDefaultFilters: Bool = true, needsAuthentication: Bool = true) {
        self._get(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension FilteredListGettable where Self: NeedsOAuth2 {
    static func _get(from node: OAuth2Node, offset: UInt, limit: UInt?, filters: [FilterType], addDefaultFilters: Bool, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._FilteredListGettable_.get(
                self, from: node, via: node.oauth2Handler.authenticatedSessionManager, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters
            )
        } else {
            DefaultImplementations._FilteredListGettable_.get(
                self, from: node, via: node.sessionManager, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters
            )
        }
    }
}
