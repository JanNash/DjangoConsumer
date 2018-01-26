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
        // Setup expectation
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        // Define Fixture type and Client type
        typealias FixtureType = MockFilteredListGettable
        typealias ClientType = MockListGettableClient
        
        // // This is the method to be tested
        let methodToBeTested: ([DRFFilterType]) -> Void = {
            FixtureType.get(filters: $0)
        }
        
        // // Setup
        // Get expected node and endpoint
        let expectedNode: TestNode = FixtureType.defaultNode as! TestNode
        let expectedEndpoint: URL = expectedNode.relativeListURL(for: FixtureType.self)
        
        // Calculate expected pagination offset
        let expectedOffset: UInt = 0
        let expectedPaginationOffset: UInt = 0
        
        // Calculate expected pagination limit
        let expectedLimit: UInt = expectedNode.defaultLimit(for: FixtureType.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: expectedEndpoint)
        let expectedPaginationLimit: UInt = min(expectedLimit, backendMaximumLimit)
        
        // Generate filters
        let date: Date = Date()
        let name: String = "A"
        let filters: [DRFFilterType] = [
            _F(.date, .__lte, date),
            _F(.name, .__icontains, name)
        ]
        let expectedFilters: [DRFFilterType] = filters
        
        // Get expected fixtures
        let expectedFixtures: [FixtureType] = {
            var fixtures: [FixtureType] = self.backend.fixtures(for: expectedEndpoint) as! [FixtureType]
        
            // FIXME: Apply filters to object array
            let filteredFixtures: [FixtureType] = fixtures
            
            // Apply limit if it makes sense
            if expectedPaginationLimit < fixtures.count {
                return Array(filteredFixtures[0..<Int(expectedPaginationLimit)])
            }
            
            return filteredFixtures
        }()
        
        // Create and connect client
        let client: MockListGettableClient = MockListGettableClient()
        FixtureType.clients = [client]
        
        // Set client method implementations
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [FixtureType] = returnedObjects as? [FixtureType] else {
                XCTFail("Wrong object type returned, expected '[\(FixtureType.self)]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(expectedFixtures, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            // FIXME: One assertion per test? :D
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(expectedNode))
            XCTAssertEqual(success.offset, expectedOffset)
            XCTAssertEqual(success.limit, expectedLimit)
            XCTAssertEqual(success.responsePagination.offset, expectedPaginationOffset)
            XCTAssertEqual(success.responsePagination.limit, expectedPaginationLimit)
            
            // FIXME: The value property of DRFFilterType is not required to be Equatable.
            // Should a DRFFilterType still be equatable by just comparing key and comparator
            // in case the value property isn'y Equatable?
            // Could it suffice to just test the count and compare the keys and
            // comparators here and not to care about the values?
            let returnedFilters: [DRFFilterType] = success.filters
            XCTAssertEqual(returnedFilters.count, expectedFilters.count)
            let unequalFilters: [(DRFFilterType, DRFFilterType)] =
                zip(returnedFilters, expectedFilters).filter({ $0.stringKey != $1.stringKey })
            XCTAssert(
                unequalFilters.isEmpty,
                "Wrong filters returned, expected '\(expectedFilters)', got \(returnedFilters), unequal filters: \(unequalFilters)"
            )
            
            // Yaaaay
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        // // END of Setup
        
        // // Test
        methodToBeTested(filters)
        
        self.waitForExpectations(timeout: 1) { _ in
            FixtureType.clients = []
        }
    }
}
