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
    static var defaultFilters: [DRFFilter] { get }
    static func get(from node: DRFNode, offset: UInt, limit: UInt, filters: [DRFFilter])
}


// MARK: Default Implementations
public extension DRFFilteredListGettable {
    static func get(from node: DRFNode = Self.defaultNode, offset: UInt = 0, limit: UInt = Self.defaultLimit, filters: [DRFFilter] = Self.defaultFilters) {
        self.get_(from: node, offset: offset, limit: limit, filters: filters)
    }
}
