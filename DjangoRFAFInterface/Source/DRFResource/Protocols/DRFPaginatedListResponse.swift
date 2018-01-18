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
public protocol DRFPaginatedListResponse: DRFListResponse {
    associatedtype PaginationType: DRFPagination
    var pagination: PaginationType { get }
}


// MARK: - DRFDefaultPaginatedListResponse
// MARK: Keys
public struct DRFPaginatedListResponseKeys {
    public static let meta: String = "meta"
}

// MARK: Struct Implementation
public struct DRFDefaultPaginatedListResponse<T: DRFListGettable> {
    // Typealiases
    public typealias PaginationType = DRFDefaultPagination
    public typealias ResultType = T
    
    // Init
    public init(json: JSON) {
        self.pagination = PaginationType(json: json[DRFPaginatedListResponseKeys.meta])
        self.results = json[DRFListResponseKeys.results].map({ ResultType(json: $0.1) })
    }
    
    // Variables
    public var pagination: PaginationType
    public var results: [ResultType]
}
