//
//  ListPostableClient.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: Protocol Declaration
public protocol ListPostableClient {
    func postedObjects<C: Collection, T: ListPostable>(_ objects: C, responseObjects: [T], to node: Node) where C.Element == T
    func failedPostingObjects<C: Collection, T: ListPostable>(_ objects: C, to node: Node, with error: Error) where C.Element == T
}
