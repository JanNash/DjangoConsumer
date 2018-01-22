//
//  DRFListGettableClient.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFListGettableClient: class {
    func failedGettingObjects<T: DRFListGettable, N: DRFNode>(ofType type: T.Type, from node: N, error: Error, offset: UInt, limit: UInt, filters: [N.FilterType])
    func got<T: DRFListGettable, N: DRFNode>(objects: [T], from node: N, pagination: DRFPagination, filters: [N.FilterType])
}
