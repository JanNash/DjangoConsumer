//
//  SinglePostableTests.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import DjangoConsumer


// MARK: // Internal
class SinglePostableTests: BaseTest {
    typealias FixtureType = MockSinglePostable
    
    func testSinglePostableDefaultNodeUsed() {
        let expectedSessionManager: TestSessionManager = FixtureType.defaultNode.testSessionManager
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        expectedSessionManager.handleRequest = { _, _ in
            expectation.fulfill()
        }
        
        FixtureType(id: "").post()
        
        self.waitForExpectations(timeout: 0.1)
    }
}
