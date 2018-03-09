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
    static func get(from node: OAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0, filters: [FilterType] = [], addDefaultFilters: Bool = false) {
        DefaultListGettableImplementations.get(
            self, from: node ?? self.defaultNode, offset: offset, limit: limit, filters: [], addDefaultFilters: false
        )
    }
}
