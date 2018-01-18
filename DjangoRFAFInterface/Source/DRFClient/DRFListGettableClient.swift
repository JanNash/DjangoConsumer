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
    func failedGettingObjects<T: DRFListGettable>(of type: T.Type, from node: DRFNode, error: Error, offset: UInt, limit: UInt, filters: [DRFFilter])
    func got(objects: DRFListGettable, from node: DRFNode, with pagination: DRFPagination)
}
