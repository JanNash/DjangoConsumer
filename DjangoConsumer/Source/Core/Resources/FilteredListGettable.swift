//
//  FilteredListGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol FilteredListGettable: ListGettable {
    init(json: JSON)
    static func get(from node: Node?, offset: UInt, limit: UInt, filters: [FilterType], addDefaultFilters: Bool)
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension FilteredListGettable where Self: NeedsNoAuth {
    static func get(from node: Node? = nil, offset: UInt = 0, limit: UInt = 0, filters: [FilterType] = [], addDefaultFilters: Bool = true) {
        self.get_(from: node ?? self.defaultNode, offset: offset, limit: limit, filters: filters, addDefaultFilters: addDefaultFilters)
    }
}
