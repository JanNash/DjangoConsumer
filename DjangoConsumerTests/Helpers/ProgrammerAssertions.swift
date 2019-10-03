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
    ProgrammerAssertions.assert?(condition, message, file, line)
    Swift.assert(condition(), message(), file: file, line: line)
}

func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    ProgrammerAssertions.precondition?(condition, message, file, line)
    Swift.precondition(condition(), message(), file: file, line: line)
}

func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    ProgrammerAssertions.assertionFailure?(message, file, line)
    Swift.assertionFailure(message(), file: file, line: line)
}

func preconditionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    ProgrammerAssertions.preconditionFailure?(message, file, line)
    Swift.preconditionFailure(message(), file: file, line: line)
}

func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    ProgrammerAssertions.fatalError?(message, file, line)
    Swift.fatalError(message(), file: file, line: line)
}


// MARK: // Assertions
struct ProgrammerAssertions {
    typealias NeverAssertion = (() -> String, StaticString, UInt) -> Never
    typealias StaticAssertion = (() -> String, StaticString, UInt) -> Void
    typealias ConditionalAssertion = (() -> Bool, () -> String, StaticString, UInt) -> Void
    
    // Custom Assertions
    static var assert: ConditionalAssertion?
    static var precondition: ConditionalAssertion?
    static var assertionFailure: StaticAssertion?
    static var preconditionFailure: NeverAssertion?
    static var fatalError: NeverAssertion?
}

#endif
