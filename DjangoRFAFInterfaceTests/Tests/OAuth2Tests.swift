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
        let expectation: XCTestExpectation = self.expectation(description: "bla")
        
        let node: TestOAuth2Node = .main
        node.authenticate(username: "ios@resmio.com", password: "password")
        
        self.waitForExpectations(timeout: 100)
    }
}
