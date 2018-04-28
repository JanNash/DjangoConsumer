//
//  ListPostableOAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
// MARK: - ListPostableOAuth2
// MARK: Protocol Declaration
public protocol ListPostableOAuth2: ListPostable, NeedsOAuth2Node {}


// MARK: - Collection
// MARK: where Self.Element: ListPostableOAuth2
public extension Collection where Self.Element: ListPostableOAuth2 {
    public func post(to node: OAuth2Node = Self.Element.defaultOAuth2Node) {
        DefaultImplementations.ListPostable.post(self, to: node, via: node.sessionManagerOAuth2)
    }
}
