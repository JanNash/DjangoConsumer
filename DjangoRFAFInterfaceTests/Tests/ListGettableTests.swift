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
    func testGettingWithoutOffsetAndLimit() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        let now: Date = Date()
        let a: _F<Date> = _F(.date, .__lte, now)
        
        let client: TestListGettableClient = TestListGettableClient()
        
        client.gotObjects_ = {
            objects, success in
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            failure in
            print("DERP")
            XCTFail()
        }
        
        TestListGettable.clients.append(client)
        
        TestListGettable.get(offset: 0, limit: 100)
        
        self.wait(for: [expectation], timeout: 10)
    }
}
