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
// MARK: - DetailGettableOAuth2
// MARK: Protocol Declaration
public protocol DetailGettableOAuth2: DetailGettable, NeedsOAuth2Node {}


// MARK: Default Implementations
public extension DetailGettableOAuth2 {
    func get(from node: OAuth2Node = Self.defaultOAuth2Node) {
        DefaultImplementations.DetailGettable.get(self, from: node, via: node.sessionManagerOAuth2)
    }
}


// MARK: - DefaultImplementations.DetailGettable
public extension DefaultImplementations.DetailGettable {
    static func get<T: DetailGettable>(_ detailGettable: T, from node: OAuth2Node) {
        self.get(detailGettable, from: node, via: node.sessionManagerOAuth2)
    }
}
