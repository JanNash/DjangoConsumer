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
// MARK: Tests for ListGettable
extension TestCase {
    func testGETWithoutParameters() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let defaultNode: TestNode = MockListGettable.defaultNode as! TestNode
        let defaultLimit: UInt = defaultNode.defaultLimit(for: MockListGettable.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: MockListGettable.self)
        let calculatedLimit: UInt = min(defaultLimit, backendMaximumLimit)
        var objects: [MockListGettable] = self.backend.fixtures(for: MockListGettable.self)
        if calculatedLimit < objects.count {
            objects = Array(objects[0..<Int(calculatedLimit)])
        }
        
        let client: MockListGettableClient = MockListGettableClient()
        MockListGettable.clients = [client]
        
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockListGettable] = returnedObjects as? [MockListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockListGettable]', got '\(type(of: returnedObjects))' instead")
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
            XCTAssertEqual(success.responsePagination.limit, calculatedLimit)
            
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get()
        
        self.waitForExpectations(timeout: 1) { _ in
            MockListGettable.clients = []
        }
    }
    
    func testGETWithGivenLimit() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let givenLimit: UInt = 5
        let defaultNode: TestNode = MockListGettable.defaultNode as! TestNode
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: MockListGettable.self)
        let calculatedLimit: UInt = min(givenLimit, backendMaximumLimit)
        var objects: [MockListGettable] = self.backend.fixtures(for: MockListGettable.self)
        if calculatedLimit < objects.count {
            objects = Array(objects[0..<Int(calculatedLimit)])
        }
        
        let client: MockListGettableClient = MockListGettableClient()
        MockListGettable.clients = [client]
        
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockListGettable] = returnedObjects as? [MockListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockListGettable]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(objects, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(defaultNode))
            XCTAssertEqual(success.offset, 0)
            XCTAssertEqual(success.limit, givenLimit)
            XCTAssertEqual(success.filters.count, 0)
            XCTAssertEqual(success.responsePagination.offset, 0)
            XCTAssertEqual(success.responsePagination.limit, calculatedLimit)
            
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(limit: givenLimit)
        
        self.waitForExpectations(timeout: 1) { _ in
            MockListGettable.clients = []
        }
    }
    
    func testGETWithGivenOffset() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let givenOffset: UInt = 2
        let defaultNode: TestNode = MockListGettable.defaultNode as! TestNode
        let defaultLimit: UInt = defaultNode.defaultLimit(for: MockListGettable.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: MockListGettable.self)
        let calculatedLimit: UInt = min(defaultLimit, backendMaximumLimit)
        var objects: [MockListGettable] = self.backend.fixtures(for: MockListGettable.self)
        if calculatedLimit < objects.count {
            objects = Array(objects[Int(givenOffset)..<Int(givenOffset + calculatedLimit)])
        } else {
            objects = Array(objects[Int(givenOffset)..<objects.count])
        }
        
        let client: MockListGettableClient = MockListGettableClient()
        MockListGettable.clients = [client]
        
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockListGettable] = returnedObjects as? [MockListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockListGettable]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(objects, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(defaultNode))
            XCTAssertEqual(success.offset, givenOffset)
            XCTAssertEqual(success.limit, defaultLimit)
            XCTAssertEqual(success.filters.count, 0)
            XCTAssertEqual(success.responsePagination.offset, givenOffset)
            XCTAssertEqual(success.responsePagination.limit, calculatedLimit)
            
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(offset: givenOffset)
        
        self.waitForExpectations(timeout: 1) { _ in
            MockListGettable.clients = []
        }
    }
    
    func testGETWithDifferentNodeWithoutParameters() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to successfully get some objects"
        )
        
        let node: TestNode = TestNode()
        let defaultLimit: UInt = node.defaultLimit(for: MockListGettable.self)
        let backendMaximumLimit: UInt = self.backend.maximumPaginationLimit(for: MockListGettable.self)
        let calculatedLimit: UInt = min(defaultLimit, backendMaximumLimit)
        var objects: [MockListGettable] = self.backend.fixtures(for: MockListGettable.self)
        if calculatedLimit < objects.count {
            objects = Array(objects[0..<Int(calculatedLimit)])
        }
        
        let client: MockListGettableClient = MockListGettableClient()
        MockListGettable.clients = [client]
        
        client.gotObjects_ = {
            returnedObjects, success in
            
            guard let returnedCastObjects: [MockListGettable] = returnedObjects as? [MockListGettable] else {
                XCTFail("Wrong object type returned, expected '[MockListGettable]', got '\(type(of: returnedObjects))' instead")
                return
            }
            
            for (obj1, obj2) in zip(objects, returnedCastObjects) {
                XCTAssertEqual(obj1.id, obj2.id)
            }
            
            XCTAssertEqual(ObjectIdentifier(success.node as! TestNode), ObjectIdentifier(node))
            XCTAssertEqual(success.offset, 0)
            XCTAssertEqual(success.limit, defaultLimit)
            XCTAssertEqual(success.filters.count, 0)
            XCTAssertEqual(success.responsePagination.offset, 0)
            XCTAssertEqual(success.responsePagination.limit, calculatedLimit)
            
            expectation.fulfill()
        }
        
        client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(from: node)
        
        self.waitForExpectations(timeout: 1) { _ in
            MockListGettable.clients = []
        }
    }
    
    func testGETFailure() {
        // Resetting the router, so the request will not be answered by the backend
        // and thus, the request will fail, which is what we wanted to test here.
        self.backend.resetRouter()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected to fail getting some objects"
        )
        
        let client: MockListGettableClient = MockListGettableClient()
        MockListGettable.clients = [client]
        
        client.gotObjects_ = {
            XCTFail("Unexpectedly got objects \($0) with success: \($1)")
        }
        
        client.failedGettingObjects_ = { _ in
            expectation.fulfill()
        }
        
        MockListGettable.get()
        
        self.waitForExpectations(timeout: 2) { _ in
            MockListGettable.clients = []
        }
    }
}
