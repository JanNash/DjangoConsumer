//
//  Pagination.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import SwiftyJSON


// MARK: // Public
// MARK: - Pagination
public protocol Pagination: JSONInitializable {
    var limit: UInt { get }
    var next: URL? { get }
    var offset: UInt { get }
    var previous: URL? { get }
    var totalCount: UInt { get }
}


// MARK: - DefaultPagination
public struct DefaultPagination: Pagination {
    // Keys
    public enum Keys {
        public static let limit: String = "limit"
        public static let next: String = "next"
        public static let offset: String = "offset"
        public static let previous: String = "previous"
        public static let totalCount: String = "total_count"
    }
    
    // Init
    public init(json: JSON) {
        // ???: There must be a better way than to force unwrap?
        // Is there a way to fail gracefully here? Should the function throw?
        // Should it maybe be a failable initializer and leave the handling
        // of a failed initialization to the ListGettable implementation?
        self.limit = json[Keys.limit].uInt!
        self.next = json[Keys.next].url
        self.offset = json[Keys.offset].uInt!
        self.previous = json[Keys.previous].url
        self.totalCount = json[Keys.totalCount].uInt!
    }
    
    // Public Variables
    public var limit: UInt
    public var next: URL?
    public var offset: UInt
    public var previous: URL?
    public var totalCount: UInt
}
