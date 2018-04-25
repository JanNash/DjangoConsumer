//
//  URL+Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: // Internal
class URLPlusTests: BaseTest {
    func testURLPlusURL() {
        let a: URL = URL(string: "http://example.com")!
        let b: URL = URL(string: "someendpoint")!
        
        XCTAssertEqual(a + b, a.appendingPathComponent(b.absoluteString))
    }
    
    func testURLPlusString() {
        let a: URL = URL(string: "http://example.com")!
        let b: String = "someendpoint"
        
        XCTAssertEqual(a + b, a.appendingPathComponent(b))
    }
    
    func testURLPlusResourceID() {
        let a: URL = URL(string: "http://example.com")!
        let b: ResourceID<MockDetailGettable> = ResourceID("1")!
        
        XCTAssertEqual(a + b, a.appendingPathComponent(b.string))
    }
}
