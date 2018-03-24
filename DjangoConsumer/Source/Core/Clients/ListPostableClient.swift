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

import Foundation


// MARK: // Public
// MARK: Protocol Declaration
public protocol ListPostableClient {
    func postedObjects<T: ListPostable>(_ objects: [T], responseObjects: [T], to node: Node)
    func failedPostingObjects<T: ListPostable>(_ objects: [T], to node: Node, with error: Error)
}
