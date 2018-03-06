//
//  MockOAuth2NodeAuthClient.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 06.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import DjangoConsumer


// MARK: // Internal
class MockOAuth2NodeAuthClient: OAuth2NodeAuthenticationClient {
    var authenticated_: (OAuth2Node) -> Void = { _ in }
    var failedAuthenticating_: (OAuth2Node, Error) -> Void = { _, _ in }
    var refreshedAuthentication_: (OAuth2Node) -> Void = { _ in }
    var failedRefreshingAuthentication_: (OAuth2Node, Error) -> Void = { _, _ in }
    var endedAuthentication_: (OAuth2Node) -> Void = { _ in }
    
    func authenticated(node: OAuth2Node) {
        self.authenticated_(node)
    }
    
    func failedAuthenticating(node: OAuth2Node, with error: Error) {
        self.failedAuthenticating_(node, error)
    }
    
    func refreshedAuthentication(for node: OAuth2Node) {
        self.refreshedAuthentication_(node)
    }
    
    func failedRefreshingAuthenticaiton(for node: OAuth2Node, with error: Error) {
        self.failedRefreshingAuthentication_(node, error)
    }
    
    func endedAuthentication(for node: OAuth2Node) {
        self.endedAuthentication_(node)
    }
}
