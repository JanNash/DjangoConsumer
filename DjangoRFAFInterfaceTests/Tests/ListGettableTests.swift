//
//  ListGettableTests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 24.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import DjangoRFAFInterface


// MARK: // Internal
class ListGettableTest: BaseTest {
    // Variables
    var client: MockListGettableClient = MockListGettableClient()
    
    
    // Setup / Teardown Overrides
    override func setUp() {
        super.setUp()
        MockListGettable.clients.append(self.client)
    }
    
    override func tearDown() {
        MockListGettable.clients = []
        super.tearDown()
    }
}


// MARK: TestCases
extension ListGettableTest {
    func testGettingWithoutAnyParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(
            description: "Expected to successfully get some objects"
        )
        
        self.client.gotObjects_ = { _, _ in
            expectation.fulfill()
        }
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get()
        
        self.wait(for: [expectation], timeout: 1)
    }
}
