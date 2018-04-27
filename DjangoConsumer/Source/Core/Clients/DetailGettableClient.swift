//
//  DetailGettableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
public protocol DetailGettableClient: class {
    func gotObject<T: DetailGettable>(_ object: T, for originator: T, from node: Node)
    func failedGettingObject<T: DetailGettable>(for originator: T, from node: Node, with error: Error)
    
    func gotObject<T>(_ object: T, for resourceID: ResourceID<T>, from node: Node)
    func failedGettingObject<T>(for resourceID: ResourceID<T>, from node: Node, with error: Error)
}
