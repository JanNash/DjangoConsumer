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
    associatedtype FilterType: DRFFilter
    init(json: JSON)
    static func get(from node: DRFNode, offset: UInt, limit: UInt, filters: [FilterType])
}


// MARK: Default Implementations
public extension DRFFilteredListGettable {
    static func get(from node: DRFNode = Self.defaultNode, offset: UInt = 0, limit: UInt = Self.defaultLimit, filters: [FilterType] = []) {
        self._get(from: node, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: // Private
private extension DRFFilteredListGettable {
    static func _get(from node: DRFNode, offset: UInt, limit: UInt, filters: [FilterType]) {
        let endpoint: URL = node.listEndpoint(for: self)
        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: filters)
        Alamofire.request(endpoint, parameters: parameters)
            .validate()
            .responseSwiftyJSON {
                switch $0.result {
                case let .failure(error):
                    print(error)
                case let .success(result):
                    let listResponse: ListRepsonseType<Self> = ListRepsonseType(json: result)
                    let pagination: ListRepsonseType.PaginationType = listResponse.pagination
                    let objects: [Self] = listResponse.results
                    print(pagination)
                    print(objects)
                }
        }
    }
}
