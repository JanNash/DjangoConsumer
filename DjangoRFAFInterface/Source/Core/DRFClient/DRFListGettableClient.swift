//
//  DRFListGettableClient.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - GETObjectListSuccess
public struct GETObjectListSuccess {
    var node: DRFNode
    var responsePagination: DRFPagination
    var offset: UInt
    var limit: UInt
    var filters: [DRFFilter<Any>]
}

// MARK: - GETObjectListFailure
public struct GETObjectListFailure {
    var objectType: DRFListGettable.Type
    var node: DRFNode
    var error: Error
    var offset: UInt
    var limit: UInt
    var filters: [DRFFilter<Any>]
}


// MARK: - DRFListGettableClient
// MARK: Protocol Declaration
public protocol DRFListGettableClient: class {
    func gotObjects(objects: [DRFListGettable], with success: GETObjectListSuccess)
    func failedGettingObjects(with failure: GETObjectListFailure)
}
