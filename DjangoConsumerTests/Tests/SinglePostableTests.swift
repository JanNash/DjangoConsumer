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
    
    func testPostingSinglePostable() {
        let singlePostable: FixtureType = FixtureType(id: "1")
        
        let expectedNode: Node = FixtureType.defaultNode
        let expectedURL: URL = expectedNode.absoluteSinglePOSTURL(for: type(of: singlePostable))
        
        let testSessionManager: TestSessionManager = expectedNode.testSessionManager
        testSessionManager.handleRequest = {
            cfg, responseHandling in
            XCTAssertEqual(cfg.url, expectedURL)
        }
        
        singlePostable.post()
    }
}
