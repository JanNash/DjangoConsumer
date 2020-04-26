//
//  IfThisIsAThen.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: // Internal
class IfThisIsAThenTests: BaseTest {
    // Helpers
    private class Foo { var fooString: String = "" }
    private class Bar {}
    
    // Tests
    func testWithReturnValue1() {
        let somethingWhichIsAFoo: Any = Foo()
        let somethingWhichIsNotAFoo: Any = Bar()
        
        let fooString: String = "blubb"
        (somethingWhichIsAFoo as! Foo).fooString = fooString
        
        let str: String? = ifT(his: somethingWhichIsAFoo, isA: Foo.self, then: { $0.fooString })
        XCTAssert(str == fooString)
        
        let otherStr: String? = ifT(his: somethingWhichIsNotAFoo, isA: Foo.self, then: { $0.fooString })
        XCTAssertNil(otherStr)
    }
    
    func testWithReturnValue2() {
        let somethingWhichIsNotAFoo: Any = Bar()
        let otherStr: String? = ifT(his: somethingWhichIsNotAFoo, isA: Foo.self, then: { $0.fooString })
        XCTAssertNil(otherStr)
    }
    
    func testWithoutReturnValue1() {
        let somethingWhichIsAFoo: Any = Foo()
        
        let fooString: String = "blubb"
        (somethingWhichIsAFoo as! Foo).fooString = fooString
        
        ifT(his: somethingWhichIsAFoo, isA: Foo.self, then: { XCTAssertEqual($0.fooString, fooString) })
    }
    
    func testWithoutReturnValue2() {
        let somethingWhichIsNotAFoo: Any = Bar()
        ifT(his: somethingWhichIsNotAFoo, isA: Foo.self, then: { _ in XCTFail("The then closure should not have been called") })
    }
}

