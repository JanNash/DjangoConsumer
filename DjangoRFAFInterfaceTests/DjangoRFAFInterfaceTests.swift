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
    override func setUp() {
        super.setUp()
        
        let node: LocalNode = Foo.defaultNode as! LocalNode
        let listRoute: LocalNode.Route = node.createListRoute(for: Foo.self)
        node.addRoute(listRoute)
        node.start()
    }
    
    override func tearDown() {
        let node: LocalNode = Foo.defaultNode as! LocalNode
        node.stop()
        Foo.defaultNode = LocalNode()
        Foo.clients.removeAll()
        
        super.tearDown()
    }
    
    func testExample() {
        let expectation: XCTestExpectation = XCTestExpectation(description: "bla")
        
        class FooListGetClient: DRFListGettableClient {
            var gotObjects: () -> Void = {}
            var failedGettingObjects: () -> Void = {}
            
            func failedGettingObjects<T: DRFListGettable>(ofType type: T.Type, from node: DRFNode, error: Error, offset: UInt, limit: UInt, filters: [DRFFilter]) {
                self.failedGettingObjects()
            }
            
            func got<T: DRFListGettable>(objects: [T], from node: DRFNode, pagination: DRFPagination, filters: [DRFFilter]) {
                self.gotObjects()
            }
        }
        
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
