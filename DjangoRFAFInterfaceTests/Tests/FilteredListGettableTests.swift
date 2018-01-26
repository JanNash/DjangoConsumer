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
        
        // Define Fixture type
        typealias FixtureType = MockFilteredListGettable
        
        // Get expected node and endpoint
        let expectedNode: TestNode = FixtureType.defaultNode as! TestNode
        let expectedEndpoint: URL = expectedNode.relativeListURL(for: FixtureType.self)
        
        // Calculate expected pagination limit
        let defaultLimit: UInt = expectedNode.defaultLimit(for: FixtureType.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: expectedEndpoint)
        let expectedPaginationLimit: UInt = min(defaultLimit, backendMaximumLimit)
        
        // Get all fixtures
        var objects: [FixtureType] = self.backend.fixtures(for: expectedEndpoint) as! [FixtureType]
        
        // Generate filters
        let date: Date = Date()
        let name: String = "A"
        let filters: [DRFFilterType] = [
            _F(.date, .__lte, date),
            _F(.name, .__icontains, name)
        ]
        
        // FIXME: Apply filters to object array
        
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
            
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(expectedNode))
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
        
        MockFilteredListGettable.get(filters: filters)
        
        self.waitForExpectations(timeout: 1) { _ in
            MockFilteredListGettable.clients = []
        }
    }
}
