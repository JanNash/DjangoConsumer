//
//  DRFPaginatedListResponse.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: // Public
// MARK: - DRFPaginatedListResponse
public protocol DRFPaginatedListResponse {
    associatedtype ResultType: DRFListGettable
    associatedtype PaginationType: DRFPagination
    init(json: JSON)
    var results: [ResultType] { get }
    var pagination: PaginationType { get }
}


// MARK: - DRFDefaultPaginatedListResponse
// MARK: Keys (static stored properties are not supported in generic types...)
public struct DRFListResponseKeys {
    public static let meta: String = "meta"
    public static let results: String = "results"
}


// MARK: Struct Implementation
public struct DRFDefaultPaginatedListResponse<T: DRFListGettable> {
    // Typealiases
    public typealias PaginationType = DRFDefaultPagination
    public typealias ResultType = T
    
    // Init
    public init(json: JSON) {
        self.pagination = PaginationType(json: json[DRFListResponseKeys.meta])
        self.results = json[DRFListResponseKeys.results].map({ ResultType(json: $0.1) })
    }
    
    // Variables
    public var pagination: PaginationType
    public var results: [ResultType]
}
