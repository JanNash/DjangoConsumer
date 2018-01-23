//
//  DjangoRFAFInterfaceTests.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 15.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
@testable import DjangoRFAFInterface

class DjangoRFAFInterfaceTests: XCTestCase {
    var backend: TestBackend = TestBackend()
    var node: TestNode = TestNode()
    
    override func setUp() {
        super.setUp()
        
        self.backend.start()
    }
    
    override func tearDown() {
        self.backend.stop()
        
        super.tearDown()
    }
    
    func testExample() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        class FooListGetClient: DRFListGettableClient {
            var gotObjects: () -> Void = {}
            var failedGettingObjects: () -> Void = {}
            
            func failedGettingObjects<T>(ofType type: T.Type, from node: DRFNode, error: Error, offset: UInt, limit: UInt, filters: [DRFFilter]) where T : DRFListGettable {
                self.failedGettingObjects()
            }
            
            func got<T>(objects: [T], from node: DRFNode, pagination: DRFPagination, filters: [DRFFilter]) where T : DRFListGettable {
                self.gotObjects()
            }
        }
        
        let filter: DRFFilter = _F(.date, .init("__someOneTimeCustomThing"), Date())
        
        let client: FooListGetClient = FooListGetClient()
        
        client.gotObjects = {
            expectation.fulfill()
        }
        
        client.failedGettingObjects = {
            print("DERP")
            XCTFail()
        }
        
        Foo.clients.append(client)
        
        Foo.get(offset: 0, limit: 100)
        
        self.wait(for: [expectation], timeout: 10)
    }
}
