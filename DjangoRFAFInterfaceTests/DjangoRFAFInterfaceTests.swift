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
        
        super.tearDown()
    }
    
    func testExample() {
        
    }
}
