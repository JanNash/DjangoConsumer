//
//  ListPostable+OAuth2.swift
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
// MARK: where Self.Element: ListPostable & NeedsOAuth2
public extension Collection where Self.Element: ListPostable & NeedsOAuth2 {
    public func post(to node: OAuth2Node = Self.Element.defaultNode, needsAuthentication: Bool = true) {
        self._post(to: node, needsAuthentication: needsAuthentication)
    }
}


// MARK: // Private
private extension Collection where Self.Element: ListPostable & NeedsOAuth2 {
    func _post(to node: OAuth2Node, needsAuthentication: Bool) {
        if needsAuthentication {
            DefaultImplementations._ListPostable_.post(self, to: node, via: node.oauth2Handler.authenticatedSessionManager)
        } else {
            DefaultImplementations._ListPostable_.post(self, to: node, via: node.sessionManager)
        }
    }
}
