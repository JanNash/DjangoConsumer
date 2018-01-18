//
//  DRFListGettable.swift
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
public protocol DRFListGettable: DRFMetaResource {
    init(json: JSON)
}


// MARK: Default Implementations
public extension DRFListGettable {
    typealias ListRepsonseType = DRFDefaultListResponse
}


// MARK: Interface
public extension DRFListGettable {
    static func get(from node: DRFNode = Self.defaultNode, offset: UInt, limit: UInt) {
        self._get(from: node, offset: offset, limit: limit)
    }
}


// MARK: // Private
private extension DRFListGettable {
    static func _get(from node: DRFNode, offset: UInt, limit: UInt) {
        let endpoint: URL = node.listEndpoint(for: self)
        let parameters: [String : Any] = [:
//            DRFPagination_.Keys.offset: offset,
//            DRFPagination_.Keys.limit: limit
        ]
        
        Alamofire.request(endpoint, parameters: parameters)
            .validate()
            .responseSwiftyJSON {
                switch $0.result {
                case let .failure(error):
                    print(error)
                case let .success(result):
                    let listResponse: ListRepsonseType<Self> = ListRepsonseType(json: result)
//                    let pagination: DRFPagination_ = listResponse.pagination
                    let objects: [Self] = listResponse.results
                    print(objects)
                }
        }
    }
}
