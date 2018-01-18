//
//  DRFNode.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFNode {
    var baseURL: URL { get }
    func listEndpoint<T: DRFListGettable>(for resourceType: T.Type) -> URL
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilter]) -> Parameters
}


// MARK: Default Implementations
public extension DRFNode {
    func parametersFrom(offset: UInt, limit: UInt, filters: [DRFFilter] = []) -> Parameters {
        var parameters: Parameters = [
            DRFDefaultPagination.Keys.offset: offset,
            DRFDefaultPagination.Keys.limit: limit
        ]
        filters.forEach({ parameters[$0.key] = $0.value })
        return parameters
    }
}
