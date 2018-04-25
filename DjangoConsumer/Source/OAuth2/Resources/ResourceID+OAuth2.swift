//
//  ResourceID+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: where T: DetailGettable & NeedsOAuth2
public extension ResourceID where T: DetailGettable & NeedsOAuth2 {
    func get(from node: OAuth2Node = T.defaultNode, needsAuthentication: Bool = true) {
        self._get(from: node, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension ResourceID where T: DetailGettable & NeedsOAuth2 {
    func _get(from node: OAuth2Node, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._ResourceID_.getResource(withID: self, from: node, via: node.oauth2Handler.authenticatedSessionManager)
        } else {
            DefaultImplementations._ResourceID_.getResource(withID: self, from: node, via: node.sessionManager)
        }
    }
}
