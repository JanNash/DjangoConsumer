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
        self.get_(from: node ?? self.defaultNode, offset: offset, limit: limit, filters: [], addDefaultFilters: false)
    }
}
