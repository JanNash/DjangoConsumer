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

import Foundation


// MARK: // Public
public protocol DetailGettableClient: class {
    // ???: The naming here is really hard, it all sounds a bit clumsy.
    // I've even thought about using something along the lines of newObject, freshObject...
    // Suggestions are very welcome :)
    func gotObject<T: DetailGettable>(_ object: T, for originator: T, from node: Node)
    func gotObject<T: DetailGettable>(_ object: T, for uri: DetailURI<T>, from node: Node)
    func failedGettingObject<T: DetailGettable>(for originator: T, from node: Node, with error: Error)
    func failedGettingObject<T: DetailGettable>(for uri: DetailURI<T>, from node: Node, with error: Error)
}
