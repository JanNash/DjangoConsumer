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
    public var node: DRFNode
    public var responsePagination: DRFPagination
    public var offset: UInt
    public var limit: UInt
    public var filters: [DRFFilter<Any>]
}


// MARK: - GETObjectListFailure
public struct GETObjectListFailure {
    public var objectType: DRFListGettable.Type
    public var node: DRFNode
    public var error: Error
    public var offset: UInt
    public var limit: UInt
    public var filters: [DRFFilter<Any>]
}


// MARK: - DRFListGettableClient
public protocol DRFListGettableClient: class {
    func gotObjects(objects: [DRFListGettable], with success: GETObjectListSuccess)
    func failedGettingObjects(with failure: GETObjectListFailure)
}
