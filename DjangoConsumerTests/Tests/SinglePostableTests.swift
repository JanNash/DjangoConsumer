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
    // FixtureType
    private typealias _FixtureType = MockSinglePostable
    
    // SetUp Override
    override func setUp() {
        super.setUp()
        
        let node: MockNode = _FixtureType.singlePOSTdefaultNode as! MockNode
        node.routes = []
        node.testDelegate?.receivedDataRequest = nil
        node.testDelegate?.mockJSONResponse = nil
    }
    
    // Tests
    func testSinglePostableDefaultNodeUsed() {
        let expectedNode: MockNode = _FixtureType.singlePOSTdefaultNode as! MockNode
        
        expectedNode.routes = [
            .singlePOST(_FixtureType.self, "singlepostables")
        ]
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected request to be handed to sessionDelegate"
        )
        
        expectedNode.testDelegate?.receivedDataRequest = { request in
            expectation.fulfill()
        }
        
        _FixtureType().post()
        
        self.waitForExpectations(timeout: 10)
    }
    
//    func testSinglePostableInjectedNodeUsed() {
//        let injectedNode: MockNode = MockNode()
//        let expectedSessionManager: TestSessionManager = injectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .createdRequest of expectedSessionManager to be called"
//        )
//
//        expectedSessionManager.createdRequest = { _ in
//            expectation.fulfill()
//        }
//
//        _FixtureType().post(to: injectedNode)
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableURL() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        let singlePostable: _FixtureType = _FixtureType()
//
//        let expectedURL: URL = expectedNode.absoluteURL(for: type(of: singlePostable), routeType: .detail, method: .post)
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssertEqual(cfg.url, expectedURL)
//            expectation.fulfill()
//        }
//
//        singlePostable.post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableMethod() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        let expectedMethod: HTTPMethod = .post
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssertEqual(cfg.method, expectedMethod)
//            expectation.fulfill()
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableParameters1() {
//        let singlePostable: _FixtureType = _FixtureType()
//
//        guard let parametersFromObject: [String : String] = singlePostable.toParameters() as? [String : String] else {
//            XCTFail("Expected singlePostable.toParameters() to be of type [String : String]")
//            return
//        }
//
//        let expectedParameters: [String : String] = [:]
//
//        XCTAssertEqual(parametersFromObject, expectedParameters)
//    }
//
//    func testSinglePostableParameters2() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        let expectedParameters: [String : String] = [:]
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            expectation.fulfill()
//
//            guard let parameters: [String : String] = cfg.parameters as? [String : String] else {
//                XCTFail("Expected requestConfiguration.parameters to be of type [String : String]")
//                return
//            }
//
//            XCTAssertEqual(expectedParameters, parameters)
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableEncoding() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssert(cfg.encoding is JSONEncoding)
//            expectation.fulfill()
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableHeaders() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssert(cfg.headers.isEmpty)
//            expectation.fulfill()
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableAcceptableStatusCodes() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        let expectedAcceptableStatusCodes: [Int] = Array(200..<300)
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssertEqual(cfg.acceptableStatusCodes, expectedAcceptableStatusCodes)
//            expectation.fulfill()
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
//
//    func testSinglePostableAcceptableContentTypes() {
//        let expectedNode: MockNode = _FixtureType._mockDefaultNode
//        let expectedSessionManager: TestSessionManager = expectedNode._testSessionManager
//        let expectation: XCTestExpectation = self.expectation(
//            description: "Expected .receivedRequestConfig of expectedSessionManager to be called"
//        )
//
//        let expectedAcceptableContentTypes: [String] = ["*/*"]
//
//        expectedSessionManager.receivedRequestConfig = { cfg in
//            XCTAssertEqual(cfg.acceptableContentTypes, expectedAcceptableContentTypes)
//            expectation.fulfill()
//        }
//
//        _FixtureType().post()
//
//        self.waitForExpectations(timeout: 10)
//    }
}
