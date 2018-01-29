//
//  DRFFilteredListGettable+OAuth2.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 29.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: where Self: DRFNeedsOAuth2
public extension DRFFilteredListGettable where Self: DRFNeedsOAuth2 {
    static func get(from node: DRFOAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0, filters: [DRFFilterType] = [], addDefaultFilters: Bool = true) {
        self.get_(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}
