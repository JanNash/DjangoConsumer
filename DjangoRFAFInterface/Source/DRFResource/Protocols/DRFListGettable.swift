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
import WeakRefCollections


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFListGettable: DRFMetaResource {
    init(json: JSON)
    static var clients: WeakRefArray<DRFListGettableClient> { get set }
    static var defaultLimit: UInt { get }
    static func get(from node: DRFNode, offset: UInt, limit: UInt)
}


// MARK: Default Implementations
public extension DRFListGettable {
    static func get(from node: DRFNode = Self.defaultNode, offset: UInt = 0, limit: UInt = Self.defaultLimit) {
        self._get(from: node, offset: offset, limit: limit, filters: [])
    }
}


// MARK: // Internal
extension DRFListGettable {
    static func get_(from node: DRFNode, offset: UInt, limit: UInt, filters: [DRFFilter]) {
        self._get(from: node, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: // Private
private extension DRFListGettable {
    static func _get(from node: DRFNode, offset: UInt, limit: UInt, filters: [DRFFilter]) {
        let endpoint: URL = node.listEndpoint(for: self)
        let parameters: Parameters = node.parametersFrom(offset: offset, limit: limit, filters: filters)
        ValidatedJSONRequest(url: endpoint, parameters: parameters).fire(
            onFailure: { error in
                self.clients.forEach({
                    $0.failedGettingObjects(
                        ofType: Self.self,
                        from: node,
                        error: error,
                        offset: offset,
                        limit: limit,
                        filters: filters
                    )
                })
            },
            onSuccess: {
                let (pagination, objects): (DRFPagination, [Self]) = node.extractListResponse(from: $0)
                self.clients.forEach({
                    $0.got(objects: objects, from: node, pagination: pagination, filters: filters)
                })
            }
        )
    }
}
