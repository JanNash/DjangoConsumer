//
//  BaseTest.swift
//  BaseTest
//
//  Created by Jan Nash (privat) on 15.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import XCTest
@testable import DjangoRFAFInterface


// MARK: // Internal
// MARK: Class Declaration
class BaseTest: XCTestCase {
    // Static Variables
    static var backend: TestBackend = TestBackend()
    
    
    // Setup / Teardown Overrides
    override class func setUp() {
        super.setUp()
        self.backend.start()
    }
    
    override class func tearDown() {
        self.backend.stop()
        super.tearDown()
    }
}
