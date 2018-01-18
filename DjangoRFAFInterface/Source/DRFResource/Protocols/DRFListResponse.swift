//
//  DRFListResponse.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: // Public
// MARK: - DRFListResponse
public protocol DRFListResponse {
    associatedtype ResultType: DRFListGettable
    init(json: JSON)
    var results: [ResultType] { get }
}


// MARK: - DRFDefaultListResponse
// MARK: Keys (static stored properties are not supported in generic types...)
public struct DRFListResponseKeys {
    public static let results: String = "results"
}


// MARK: Struct Declaration
public struct DRFDefaultListResponse<T: DRFListGettable>: DRFListResponse {
    public typealias ResultType = T
    
    // Init
    public init(json: JSON) {
        self.results = json[DRFListResponseKeys.results].map({ ResultType(json: $0.1) })
    }
    
    // Variables
    public var results: [T]
}
