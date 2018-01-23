//
//  BaseTest.swift
//  BaseTest
//
//  Created by Jan Nash (privat) on 15.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
@testable import DjangoRFAFInterface


// MARK: // Internal
// MARK: Class Declaration
class BaseTest: XCTestCase {
    // Variables
    var backend: TestBackend = TestBackend()
    var node: TestNode = TestNode()
//    var listGettableClient: TestListGettableClient = TestListGettableClient()
    
    
    // Setup / Teardown Overrides
    override func setUp() {
        super.setUp()
        self.backend.start()
    }
    
    override func tearDown() {
        self.backend.stop()
        super.tearDown()
    }
    
    func testExample() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        let now: Date = Date()
        let a: _F<Date> = _F(.date, .__lte, now)
        
        let client: TestListGettableClient = TestListGettableClient()
        
//        client.gotObjects = {
//            expectation.fulfill()
//        }
//        
//        client.failedGettingObjects = {
//            print("DERP")
//            XCTFail()
//        }
        
        TestListGettable.clients.append(client)
        
        TestListGettable.get(offset: 0, limit: 100)
        
        self.wait(for: [expectation], timeout: 10)
    }
}
