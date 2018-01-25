//
//  FilteredListGettableTests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 24.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Tests for FilteredListGettable
extension TestCase {
    func testGettingWithoutAnyParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        let client: MockListGettableClient = MockListGettableClient()
        client.gotObjects_ = {
            objects, success in
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            failure in
            XCTFail()
        }
        
        MockListGettable.clients.append(client)
        MockListGettable.get()
        
        self.wait(for: [expectation], timeout: 10)
    }
}
