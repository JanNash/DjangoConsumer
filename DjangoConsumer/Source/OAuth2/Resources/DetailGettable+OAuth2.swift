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

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsOAuth2 {
    func get(from node: OAuth2Node = Self.defaultNode, needsAuthentication: Bool = true) {
        self._get(from: node, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension DetailGettable where Self: NeedsOAuth2 {
    func _get(from node: OAuth2Node, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._DetailGettable_.get(self, from: node, via: node.oauth2Handler.authenticatedSessionManager)
        } else {
            DefaultImplementations._DetailGettable_.get(self, from: node, via: node.sessionManager)
        }
    }
}
