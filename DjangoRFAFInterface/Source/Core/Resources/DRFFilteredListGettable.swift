//
//  DRFFilteredListGettable.swift
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
public protocol DRFFilteredListGettable: DRFListGettable {
    init(json: JSON)
    static func get(from node: DRFNode?, offset: UInt, limit: UInt, filters: [DRFFilterType], addDefaultFilters: Bool)
}


// MARK: Default Implementations
// MARK: where Self: DRFNeedsNoAuth
public extension DRFFilteredListGettable where Self: DRFNeedsNoAuth {
    static func get(from node: DRFNode? = nil, offset: UInt = 0, limit: UInt = 0, filters: [DRFFilterType] = [], addDefaultFilters: Bool = true) {
        self.get_(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}


// MARK: where Self: DRFNeedsOAuth2
public extension DRFFilteredListGettable where Self: DRFNeedsOAuth2 {
    static func get(from node: DRFOAuth2Node? = nil, offset: UInt = 0, limit: UInt = 0, filters: [DRFFilterType] = [], addDefaultFilters: Bool = true) {
        self.get_(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}
