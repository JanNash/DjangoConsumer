//
//  DetailPostableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 06.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: Protocol Declaration
public protocol DetailPostableClient {
    func postedObject<T: DetailPostable>(_ object: T, responseObject: T, to node: Node)
    func failedPostingObject<T: DetailPostable>(_ object: T, to node: Node, with error: Error)
}
