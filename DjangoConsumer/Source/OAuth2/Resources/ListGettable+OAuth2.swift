//
//  ListGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 29.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsOAuth2
extension ListGettable where Self: NeedsOAuth2 {
    static func get(from node: OAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0) {
        self.get_(from: node ?? self.defaultNode, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}
