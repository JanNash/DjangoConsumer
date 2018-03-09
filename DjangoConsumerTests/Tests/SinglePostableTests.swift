//
//  SinglePostableTests.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash on 07.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
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
        
        FixtureType().post()
        
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
        
        FixtureType().post(to: injectedNode)
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableURL() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let singlePostable: FixtureType = FixtureType()
        
        let expectedURL: URL = expectedNode.absoluteURL(for: type(of: singlePostable), routeType: .detail, method: .post)
        
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
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableParameters1() {
        let id: String = "123456"
        let singlePostable: FixtureType = FixtureType()
        
        guard let parametersFromObject: [String : String] = singlePostable.toParameters() as? [String : String] else {
            XCTFail("Expected singlePostable.toParameters() to be of type [String : String]")
            return
        }
        
        let expectedParameters: [String : String] = [:]
        
        XCTAssertEqual(parametersFromObject, expectedParameters)
    }
    
    func testSinglePostableParameters2() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let id: String = "123456"
        let expectedParameters: [String : String] = [:]
        
        expectedSessionManager.handleRequest = { cfg, _ in
            expectation.fulfill()
            
            guard let parameters: [String : String] = cfg.parameters as? [String : String] else {
                XCTFail("Expected requestConfiguration.parameters to be of type [String : String]")
                return
            }
            
            XCTAssertEqual(expectedParameters, parameters)
        }
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableEncoding() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssert(cfg.encoding is JSONEncoding)
            expectation.fulfill()
        }
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableHeaders() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssert(cfg.headers.isEmpty)
            expectation.fulfill()
        }
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableAcceptableStatusCodes() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let expectedAcceptableStatusCodes: [Int] = Array(200..<300)
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssertEqual(cfg.acceptableStatusCodes, expectedAcceptableStatusCodes)
            expectation.fulfill()
        }
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSinglePostableAcceptableContentTypes() {
        let expectedNode: Node = FixtureType.defaultNode
        let expectedSessionManager: TestSessionManager = expectedNode.testSessionManager
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected .handleRequest of expectedSessionManager to be called"
        )
        
        let expectedAcceptableContentTypes: [String] = ["*/*"]
        
        expectedSessionManager.handleRequest = { cfg, _ in
            XCTAssertEqual(cfg.acceptableContentTypes, expectedAcceptableContentTypes)
            expectation.fulfill()
        }
        
        FixtureType().post()
        
        self.waitForExpectations(timeout: 0.1)
    }
}
