//
//  SinglePostableTests.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import Alamofire
import DjangoConsumer


// MARK: // Internal
class SinglePostableTests: BaseTest {
    // FixtureType typealias
    typealias FixtureType = MockSinglePostable
    
    // Setup Override
    override func setUp() {
        super.setUp()
        FixtureType.defaultNode = MockNode.main
        MockNode.main.testSessionManager.handleRequest = nil
    }
    
    // Tests
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
    
    func testSinglePostableInjectedNodeUsed() {
        let injectedNode: MockNode = MockNode()
        let expectedSessionManager: TestSessionManager = injectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        expectedSessionManager.handleRequest = { _, _ in
            expectation.fulfill()
        }
        
        FixtureType(id: "").post(to: injectedNode)
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableURL() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let singlePostable: FixtureType = FixtureType(id: "")
        
        let expectedURL: URL = expectedNode.absoluteSinglePOSTURL(for: type(of: singlePostable))
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssertEqual(cfg.url, expectedURL)
            expectation.fulfill()
        }
        
        singlePostable.post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableMethod() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let expectedMethod: HTTPMethod = .post
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssertEqual(cfg.method, expectedMethod)
            expectation.fulfill()
        }
        
        FixtureType(id: "").post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableParameters() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let id: String = "123456"
        let singlePostable: FixtureType = FixtureType(id: id)
        
        let expectedParameters: [String : String] = [FixtureType.Keys.id : id]
        
        expectedSessionManager.handleRequest = { cfg, _ in
            expectation.fulfill()
            
            guard let parameters: [String : String] = cfg.parameters as? [String : String] else {
                XCTFail("Expected requestConfiguration to be of type [String : String]")
                return
            }
            
            XCTAssertEqual(expectedParameters, parameters)
        }
        
        singlePostable.post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableEncoding() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let singlePostable: FixtureType = FixtureType(id: "")
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssert(cfg.encoding is JSONEncoding)
            expectation.fulfill()
        }
        
        singlePostable.post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableHeaders() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let singlePostable: FixtureType = FixtureType(id: "")
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssert(cfg.headers.isEmpty)
            expectation.fulfill()
        }
        
        singlePostable.post()
        
        self.waitForExpectations(timeout: 0.1)
    }
}
