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
    func testGETWithFilters() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let defaultNode: TestNode = MockFilteredListGettable.defaultNode as! TestNode
        
        // Calculate expected pagination limit
        let defaultLimit: UInt = defaultNode.defaultLimit(for: MockListGettable.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: MockFilteredListGettable.self)
        let expectedPaginationLimit: UInt = min(defaultLimit, backendMaximumLimit)
        
        // Get all fixtures
        var objects: [MockFilteredListGettable] = self.backend.fixtures(for: MockFilteredListGettable.self)
        
        // Generate filters
        let date: Date = Date()
        let dateFilter: _F<Date> = _F(.date, .__lte, date)
        
        let name: String = "A"
        let nameFilter: _F<String> = _F(.name, .__icontains, name)
        
//        let filters = [dateFilter, nameFilter]
        
        if expectedPaginationLimit < objects.count {
            objects = Array(objects[0..<Int(expectedPaginationLimit)])
        }
        
        let client: MockListGettableClient = MockListGettableClient()
        MockFilteredListGettable.clients = [client]
        
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockFilteredListGettable] = returnedObjects as? [MockFilteredListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockFilteredListGettable]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(objects, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(defaultNode))
            XCTAssertEqual(success.offset, 0)
            XCTAssertEqual(success.limit, defaultLimit)
            XCTAssertEqual(success.filters.count, 0)
            XCTAssertEqual(success.responsePagination.offset, 0)
            XCTAssertEqual(success.responsePagination.limit, expectedPaginationLimit)
            
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
//        MockFilteredListGettable.get(filters: )
        
        self.waitForExpectations(timeout: 1) { _ in
            MockFilteredListGettable.clients = []
        }
    }
}
