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
extension TestCase {
    func testLoggingIn() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected node to successfully authenticate"
        )
        
        let node: MockOAuth2Node = .main
        
        let client: MockOAuth2NodeAuthClient = MockOAuth2NodeAuthClient()
        client.authenticated_ = { _ in expectation.fulfill() }
        node.oauth2Clients.append(client)
        
        node.authenticate(username: "username", password: "password")
        
        self.waitForExpectations(timeout: 1)
    }
}
