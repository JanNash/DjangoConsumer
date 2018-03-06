//
//  FilteredListGettableTests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 24.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Tests for FilteredListGettable
extension TestCase {
    func testGETWithFilters() {
        // Setup expectation
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let backend: TestBackend = self.backend
        
        // Define Fixture type and Client type
        typealias FixtureType = MockFilteredListGettable
        typealias ClientType = MockListGettableClient
        
        // // This is the method to be tested
        let methodToBeTested: ([FilterType]) -> Void = {
            FixtureType.get(filters: $0)
        }
        
        // // Setup
        // Get expected node and endpoint
        let expectedNode: MockNode = FixtureType.defaultNode as! MockNode
        let expectedRoutePattern: TestBackend.RoutePattern = .GET_list_mockFilteredListGettables
        let expectedRoutePatternString: String = expectedRoutePattern.rawValue
        
        // Calculate expected pagination offset
        let expectedOffset: UInt = 0
        let expectedPaginationOffset: UInt = 0
        
        // Calculate expected limit (since none is passed, default should be used)
        // and expected pagination limit
        let expectedLimit: UInt = expectedNode.defaultLimit(for: FixtureType.self)
        let backendMaximumLimit: UInt = backend.maximumPaginationLimit(for: expectedRoutePatternString)
        let expectedPaginationLimit: UInt = min(expectedLimit, backendMaximumLimit)
        
        // Generate filters
        let date: Date = Date()
        let name: String = "A"
        let filters: [FilterType] = [
            _F(.date, .__lte, date),
            _F(.name, .__icontains, name)
        ]
        let expectedFilters: [FilterType] = filters
        let expectedFilterParameters: Parameters = expectedNode.parametersFrom(filters: expectedFilters)
        let expectedFilterClosure: (ListGettable) -> Bool = backend.filterClosure(
            for: expectedFilterParameters, with: expectedRoutePattern
        )
        
        // Get expected fixtures
        let expectedFixtures: [FixtureType] = {
            let fixtures: [FixtureType] = backend.fixtures(for: expectedRoutePatternString) as! [FixtureType]
        
            // Apply filters
            let filteredFixtures: [FixtureType] = fixtures.filter(expectedFilterClosure)
            
            // Apply limit if necessary
            if expectedPaginationLimit < fixtures.count {
                return Array(filteredFixtures[0..<Int(expectedPaginationLimit)])
            }
            
            return filteredFixtures
        }()
        
        // Create and connect client
        let client: ClientType = ClientType()
        FixtureType.listGettableClients = [client]
        
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
            XCTAssertEqual(ObjectIdentifier(success.node as! MockNode), ObjectIdentifier(expectedNode))
            XCTAssertEqual(success.offset, expectedOffset)
            XCTAssertEqual(success.limit, expectedLimit)
            XCTAssertEqual(success.responsePagination.offset, expectedPaginationOffset)
            XCTAssertEqual(success.responsePagination.limit, expectedPaginationLimit)
            
            // FIXME: The value property of FilterType is not required to be Equatable.
            // Should a FilterType still be equatable by just comparing key and comparator
            // in case the value property isn't Equatable?
            // Could it suffice to just test the count and compare the keys and
            // comparators here and not to care about the values?
            let returnedFilters: [FilterType] = success.filters
            XCTAssertEqual(returnedFilters.count, expectedFilters.count)
            let unequalFilters: [(FilterType, FilterType)] =
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
        
        // // Run Test
        methodToBeTested(filters)
        
        self.waitForExpectations(timeout: 10) { _ in
            FixtureType.listGettableClients = []
        }
    }
}
