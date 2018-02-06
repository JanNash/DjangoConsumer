//
//  OAuth2Tests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 06.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import Alamofire
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Tests for OAuth2
extension TestCase: DRFOAuth2NodeAuthenticationClient {
    func authenticated(node: DRFOAuth2Node) {
        node.refreshAuthentication()
    }
    
    func failedAuthenticating(node: DRFOAuth2Node, with error: Error) {
        print("")
    }
    
    func refreshedAuthentication(for node: DRFOAuth2Node) {
        node.endAuthentication()
    }
    
    func failedRefreshingAuthenticaiton(for node: DRFOAuth2Node, with error: Error) {
        print("")
    }
    
    func endedAuthentication(for node: DRFOAuth2Node) {
        print("")
    }
    
    func testLoggingIn() {
        let expectation: XCTestExpectation = self.expectation(description: "bla")
        
        let node: TestOAuth2Node = .main
        node.oauth2Clients.append(self)
        node.authenticate(username: "ios@resmio.com", password: "password")
        
        self.waitForExpectations(timeout: 100)
    }
}
