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
    static func get<T: DRFNode>(from node: T, offset: UInt, limit: UInt, filters: [T.FilterType], addDefaultFilters: Bool)
}


// MARK: Default Implementations
public extension DRFFilteredListGettable {
    static func get<T: DRFNode>(from node: T? = nil, offset: UInt = 0, limit: UInt? = nil, filters: [T.FilterType] = [], addDefaultFilters: Bool = true) {
        self.get_(from: node, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}
