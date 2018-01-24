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
    func testGETWithoutParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(
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
        
        self.client.gotObjects_ = {
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
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get()
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testGETWithGivenLimit() {
        let expectation: XCTestExpectation = XCTestExpectation(
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
        
        self.client.gotObjects_ = {
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
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(limit: givenLimit)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testGETWithGivenOffset() {
        let expectation: XCTestExpectation = XCTestExpectation(
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
        
        self.client.gotObjects_ = {
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
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(offset: givenOffset)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testGETWithDifferentNodeWithoutParameters() {
        let expectation: XCTestExpectation = XCTestExpectation(
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
        
        self.client.gotObjects_ = {
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
        
        self.client.failedGettingObjects_ = {
            XCTFail("Failed getting objects with failure: \($0)")
        }
        
        MockListGettable.get(from: node)
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testGETFailure() {
        let expectation: XCTestExpectation = XCTestExpectation(
            description: "Expected to fail getting some objects"
        )
        
        self.client.gotObjects_ = {
            XCTFail("Unexpectedly got objects \($0) with success: \($1)")
        }
        
        self.client.failedGettingObjects_ = { _ in
            expectation.fulfill()
        }
        
        MockListGettable.get()
        
        self.wait(for: [expectation], timeout: 10)
    }
}
