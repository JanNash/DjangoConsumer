//
//  DetailGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: Protocol Declaration
public protocol DetailGettableOAuth2: DetailGettable, NeedsOAuth2Node {}


// MARK: Default Implementations
public extension DetailGettableOAuth2 {
    func get(from node: OAuth2Node = Self.defaultOAuth2Node) {
        DefaultImplementations.DetailGettable.get(self, from: node, via: node.sessionManagerOAuth2)
    }
}
