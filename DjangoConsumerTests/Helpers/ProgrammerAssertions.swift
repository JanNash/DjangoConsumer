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
    ProgrammerAssertions.assert(condition(), message(), file, line)
}

func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    ProgrammerAssertions.precondition(condition(), message(), file, line)
}

func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    ProgrammerAssertions.assertionFailure(message(), file, line)
}

func preconditionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    ProgrammerAssertions.preconditionFailure(message(), file, line)
}

func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    ProgrammerAssertions.fatalError(message(), file, line)
}


// MARK: // Assertions
struct ProgrammerAssertions {
    typealias NeverAssertion = (String, StaticString, UInt) -> Never
    typealias StaticAssertion = (String, StaticString, UInt) -> Void
    typealias ConditionalAssertion = (Bool, String, StaticString, UInt) -> Void
    
    // Custom Assertions
    static var assert: ConditionalAssertion         = ProgrammerAssertions.swiftAssert
    static var precondition: ConditionalAssertion   = ProgrammerAssertions.swiftPrecondition
    static var assertionFailure: StaticAssertion    = ProgrammerAssertions.swiftAssertionFailure
    static var preconditionFailure: NeverAssertion  = ProgrammerAssertions.swiftPreconditionFailure
    static var fatalError: NeverAssertion           = ProgrammerAssertions.swiftFatalError
    
    // Swift Assertions
    static let swiftAssert: ConditionalAssertion        = { Swift.assert($0, $1, file: $2, line: $3) }
    static let swiftPrecondition: ConditionalAssertion  = { Swift.precondition($0, $1, file: $2, line: $3) }
    static let swiftAssertionFailure: StaticAssertion   = { Swift.assertionFailure($0, file: $1, line: $2) }
    static let swiftPreconditionFailure: NeverAssertion = { Swift.preconditionFailure($0, file: $1, line: $2) }
    static let swiftFatalError: NeverAssertion          = { Swift.fatalError($0, file: $1, line: $2) }
    
    // Reset Functions
    static func resetAssert()               { ProgrammerAssertions.assert = ProgrammerAssertions.swiftAssert }
    static func resetPrecondition()         { ProgrammerAssertions.precondition = ProgrammerAssertions.swiftPrecondition }
    static func resetAssertionFailure()     { ProgrammerAssertions.assertionFailure = ProgrammerAssertions.swiftAssertionFailure }
    static func resetPreconditionFailure()  { ProgrammerAssertions.preconditionFailure = ProgrammerAssertions.swiftPreconditionFailure }
    static func resetFatalError()           { ProgrammerAssertions.fatalError = ProgrammerAssertions.swiftFatalError }
}

#endif
