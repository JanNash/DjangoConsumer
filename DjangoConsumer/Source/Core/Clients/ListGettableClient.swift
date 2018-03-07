//
//  ListGettableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 19.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - GETObjectListSuccess
public struct GETObjectListSuccess {
    public var node: Node
    public var responsePagination: Pagination
    public var offset: UInt
    public var limit: UInt
    public var filters: [FilterType]
}


// MARK: - GETObjectListFailure
public struct GETObjectListFailure {
    public var objectType: ListGettable.Type
    public var node: Node
    public var error: Error
    public var offset: UInt
    public var limit: UInt
    public var filters: [FilterType]
}


// MARK: - ListGettableClient
public protocol ListGettableClient: class {
    func gotObjects(objects: [ListGettable], with success: GETObjectListSuccess)
    func failedGettingObjects(with failure: GETObjectListFailure)
}
