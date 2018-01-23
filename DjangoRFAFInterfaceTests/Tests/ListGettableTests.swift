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
    var client: TestListGettableClient = TestListGettableClient()
}


// MARK: TestCases
extension ListGettableTest {
    func testGettingWithoutAnyParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        self.client.gotObjects_ = {
            objects, success in
            expectation.fulfill()
        }
        
        self.client.failedGettingObjects_ = {
            failure in
            XCTFail()
        }
        
        TestListGettable.clients.append(self.client)
        TestListGettable.get()
        
        self.wait(for: [expectation], timeout: 10)
    }
}
