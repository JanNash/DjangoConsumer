//
//  ProgrammerAssertions.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

#if DEBUG

import Foundation


// MARK: // Internal
// MARK: Assertion Functions
func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    Assertions.assert(condition(), message(), file, line)
}

func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    Assertions.precondition(condition(), message(), file, line)
}

func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    Assertions.assertionFailure(message(), file, line)
}

func preconditionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    Assertions.preconditionFailure(message(), file, line)
    // This is needed to satisfy the return type `Never`, since `AssertFunction` returns Void
    // It will never be executed, since a `repeat { RunLoop.main.run() } while (true)` is
    // injected into the custom assertions in `XCTestCase (ProgrammerAssertions).swift`.
    Swift.preconditionFailure(
        "This should never be executed. If it is executed, there's likely " +
        "a serious programming error in `XCTestCase (ProgrammerAssertions).swift`"
    )
}

func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    Assertions.fatalError(message(), file, line)
    // This is needed to satisfy the return type `Never`, since `AssertFunction` returns Void
    // It will never be executed, since a `repeat { RunLoop.main.run() } while (true)` is
    // injected into the custom assertions in `XCTestCase (ProgrammerAssertions).swift`.
    Swift.fatalError(
        "This should never be executed. If it is executed, there's likely " +
        "a serious programming error in `XCTestCase (ProgrammerAssertions).swift`"
    )
}


// MARK: // Assertions
struct Assertions {
    typealias Assertion = (String, StaticString, UInt) -> Void
    typealias ConditionalAssertion = (Bool, String, StaticString, UInt) -> Void
    
    // Custom Assertions
    static var assert: ConditionalAssertion         = Assertions.swiftAssert
    static var precondition: ConditionalAssertion   = Assertions.swiftPrecondition
    static var assertionFailure: Assertion          = Assertions.swiftAssertionFailure
    static var preconditionFailure: Assertion       = Assertions.swiftPreconditionFailure
    static var fatalError: Assertion                = Assertions.swiftFatalError
    
    // Swift Assertions
    static let swiftAssert: ConditionalAssertion        = { Swift.assert($0, $1, file: $2, line: $3) }
    static let swiftPrecondition: ConditionalAssertion  = { Swift.precondition($0, $1, file: $2, line: $3) }
    static let swiftAssertionFailure: Assertion         = { Swift.assertionFailure($0, file: $1, line: $2) }
    static let swiftPreconditionFailure: Assertion      = { Swift.preconditionFailure($0, file: $1, line: $2) }
    static let swiftFatalError: Assertion               = { Swift.fatalError($0, file: $1, line: $2) }
    
    // Reset Functions
    static func resetAssert()               { Assertions.assert = Assertions.swiftAssert }
    static func resetAssertionFailure()     { Assertions.assertionFailure = Assertions.swiftAssertionFailure }
    static func resetPrecondition()         { Assertions.precondition = Assertions.swiftPrecondition }
    static func resetPreconditionFailure()  { Assertions.preconditionFailure = Assertions.swiftPreconditionFailure }
    static func resetFatalError()           { Assertions.fatalError = Assertions.swiftFatalError }
}

#endif
