//
//  SinglePostable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 06.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsOAuth2
public extension SinglePostable where Self: NeedsOAuth2 {
    func post(to node: OAuth2Node = Self.defaultNode, needsAuthentication: Bool = true) {
        self._post(to: node, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension SinglePostable where Self: NeedsOAuth2 {
    func _post(to node: OAuth2Node, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._SinglePostable_.post(
                self, to: node, via: node.oauth2Handler.authenticatedSessionManager, additionalHeaders: [:], additionalParameters: [:]
            )
        } else {
            DefaultImplementations._SinglePostable_.post(
                self, to: node, via: node.sessionManager, additionalHeaders: [:], additionalParameters: [:]
            )
        }
    }
}
