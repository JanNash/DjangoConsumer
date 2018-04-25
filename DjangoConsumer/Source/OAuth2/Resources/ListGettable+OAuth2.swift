//
//  ListGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 29.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsOAuth2
extension ListGettable where Self: NeedsOAuth2 {
    static func get(from node: OAuth2Node = Self.defaultNode, offset: UInt = 0, limit: UInt? = nil, needsAuthentication: Bool = true) {
        self._get(from: node, offset: offset, limit: limit, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension ListGettable {
    static func _get(from node: OAuth2Node, offset: UInt, limit: UInt?, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._ListGettable_.get(
                self, from: node, via: node.oauth2Handler.authenticatedSessionManager, offset: offset, limit: limit, filters: []
            )
        } else {
            DefaultImplementations._ListGettable_.get(
                self, from: node, via: node.sessionManager, offset: offset, limit: limit, filters: []
            )
        }
    }
}
