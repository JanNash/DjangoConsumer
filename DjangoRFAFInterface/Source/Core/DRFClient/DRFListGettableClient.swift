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
public struct GETObjectListSuccess<T: DRFListGettable> {
    var node: DRFNode
    var responsePagination: DRFPagination
    var offset: UInt
    var limit: UInt
    var filters: [DRFFilter<Any>]
}

// MARK: - GETObjectListFailure
public struct GETObjectListFailure<T: DRFListGettable> {
    var objectType: T.Type
    var node: DRFNode
    var error: Error
    var offset: UInt
    var limit: UInt
    var filters: [DRFFilter<Any>]
}


// MARK: - DRFListGettableClient
// MARK: Protocol Declaration
public protocol DRFListGettableClient: class {
    func gotObjects<T>(objects: [T], with success: GETObjectListSuccess<T>)
    func failedGettingObjects<T>(with failure: GETObjectListFailure<T>)
}
