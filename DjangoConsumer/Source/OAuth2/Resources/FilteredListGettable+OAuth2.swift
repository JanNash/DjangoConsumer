//
//  FilteredListGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 29.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: where Self: NeedsOAuth2
public extension FilteredListGettable where Self: NeedsOAuth2 {
    static func get(from node: OAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0, filters: [FilterType] = [], addDefaultFilters: Bool = false) {
        self.get_(from: node ?? self.defaultNode, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}
