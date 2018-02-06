//
//  MockOAuth2NodeAuthClient.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 06.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
class MockOAuth2NodeAuthClient: DRFOAuth2NodeAuthenticationClient {
    var authenticated_: (DRFOAuth2Node) -> Void = { _ in }
    var failedAuthenticating_: (DRFOAuth2Node, Error) -> Void = { _, _ in }
    var refreshedAuthentication_: (DRFOAuth2Node) -> Void = { _ in }
    var failedRefreshingAuthentication_: (DRFOAuth2Node, Error) -> Void = { _, _ in }
    var endedAuthentication_: (DRFOAuth2Node) -> Void = { _ in }
    
    func authenticated(node: DRFOAuth2Node) {
        self.authenticated_(node)
    }
    
    func failedAuthenticating(node: DRFOAuth2Node, with error: Error) {
        self.failedAuthenticating_(node, error)
    }
    
    func refreshedAuthentication(for node: DRFOAuth2Node) {
        self.refreshedAuthentication_(node)
    }
    
    func failedRefreshingAuthenticaiton(for node: DRFOAuth2Node, with error: Error) {
        self.failedRefreshingAuthentication_(node, error)
    }
    
    func endedAuthentication(for node: DRFOAuth2Node) {
        self.endedAuthentication_(node)
    }
}
