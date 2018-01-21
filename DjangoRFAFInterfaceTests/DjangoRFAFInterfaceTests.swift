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
        
//        Foo.allFixtureObjects = [
//            Foo(id: "1", bar: "A"),
//            Foo(id: "2", bar: "B"),
//            Foo(id: "3", bar: "C"),
//            Foo(id: "4", bar: "D"),
//            Foo(id: "5", bar: "E"),
//            Foo(id: "6", bar: "F"),
//        ]
//
//        let node: LocalTestNode = Foo.defaultNode as! LocalTestNode
//        let listRoute: LocalTestNode.Route = node.createListRoute(for: Foo.self)
//        node.addRoute(listRoute)
//        node.start()
    }
    
    override func tearDown() {
//        let node: LocalNode = Foo.defaultNode as! LocalTestNode
//        node.stop()
//        Foo.defaultNode = LocalTestNode()
//        Foo.clients = []
//        Foo.allFixtureObjects = []
        
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
