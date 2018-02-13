//
//  DetailGettableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DetailGettableClient: class {
    func gotObject<T: DetailGettable>(object: T, from node: Node)
    func failedGettingObject<T: DetailGettable>(_ object: T, from node: Node, with error: Error)
}
