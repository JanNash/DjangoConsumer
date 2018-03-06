//
//  BaseTest.swift
//  BaseTest
//
//  Created by Jan Nash on 15.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class TestCase: XCTestCase {
    // Static Variables
    var backend: TestBackend = TestBackend()
    
    
    // Setup / Teardown Overrides
    override func setUp() {
        super.setUp()
        self.backend.reset()
        self.backend.start()
    }
    
    override func tearDown() {
        self.backend.stop()
        super.tearDown()
    }
}
