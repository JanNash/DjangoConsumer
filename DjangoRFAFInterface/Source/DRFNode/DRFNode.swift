//
//  DRFNode.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFNode {
    var baseURL: URL { get }
    
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilter]) -> Parameters
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters
    func parametersFrom(filters: [DRFFilter]) -> Parameters
    
    func listEndpoint<T: DRFListGettable>(for resourceType: T.Type) -> URL
    func extractListResponse<T: DRFListGettable>(from json: JSON) -> (DRFPagination, [T])
}


// MARK: DRFListResponseKeys
public struct DRFListResponseKeys {
    public static let meta: String = "meta"
    public static let results: String = "results"
}


// MARK: Default Implementations
// MARK: Parameter Generation
public extension DRFNode {
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilter] = []) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit, filters: filters)
    }
    
    func parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return self._parametersFrom(offset: offset, limit: limit)
    }
    
    func parametersFrom(filters: [DRFFilter]) -> Parameters {
        return filters.reduce(into: [:], { $0[$1.key] = $1.value })
    }
}


// MARK: ListResponse Extraction
public extension DRFNode {
    func extractListResponse<T: DRFListGettable, P: DRFPagination>(from json: JSON) -> (P, [T]) {
        return self._extractListResponse(from: json)
    }
}


// MARK: // Private
// MARK: Parameter Generation Implementation
private extension DRFNode {
    func _parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilter] = []) -> Parameters {
        var parameters: Parameters = [:]
        let writeToParameters: (String, Any) -> Void = { parameters[$0] = $1 }
        self.parametersFrom(offset: offset, limit: limit).forEach(writeToParameters)
        self.parametersFrom(filters: filters).forEach(writeToParameters)
        return parameters
    }
    
    func _parametersFrom(offset: UInt, limit: UInt) -> Parameters {
        return [
            DRFDefaultPagination.Keys.offset: offset,
            DRFDefaultPagination.Keys.limit: limit
        ]
    }
}


// MARK: ListResponse Extraction
private extension DRFNode {
    func _extractListResponse<T: DRFListGettable, P: DRFPagination>(from json: JSON) -> (P, [T]) {
        let pagination: P = P(json: json[DRFListResponseKeys.meta])
        let objects: [T] = json[DRFListResponseKeys.results].array!.map(T.init)
        return (pagination, objects)
    }
}

