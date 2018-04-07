//
//  XCTestCase (ProgrammerAssertions).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import XCTest
@testable import DjangoConsumer


// MARK: // Internal
// MARK: XCTestCase extension
extension XCTestCase {
    enum Assertion {
        case assert, precondition, assertionFailure, preconditionFailure, fatalError
    }
    
    func expect(_ assertion: Assertion, expectedMessage: String?, timeout: TimeInterval, _ testCase: @escaping () -> Void) {
        self._expect(assertion, expectedMessage, timeout, testCase)
    }
}


// MARK: // Private
// MARK: Typealiases
private typealias _PA = ProgrammerAssertions
private typealias _AssertionParams = (condition: Bool, message: String)
private typealias _PatchFunction = (@escaping _PA.ConditionalAssertion) -> Void
private typealias _ResetFunction = () -> Void
private typealias _TestCase = () -> Void


// MARK: _AssertionConfig
private struct _AssertionConfig {
    // Private Init
    private init(functionName: String, patchFunction: @escaping _PatchFunction, resetFunction: @escaping _ResetFunction) {
        self.functionName = functionName
        self.patchFunction = patchFunction
        self.resetFunction = resetFunction
    }
    
    // Constant Stored Properties
    let functionName: String
    let patchFunction: _PatchFunction
    let resetFunction: _ResetFunction
    
    // Predefinded Instances
    static let assert: _AssertionConfig = _AssertionConfig(
        functionName: "assert()",
        patchFunction: { _PA.assert = $0 },
        resetFunction: { _PA.assert = nil }
    )
    
    static let precondition: _AssertionConfig = _AssertionConfig(
        functionName: "precondition()",
        patchFunction: { _PA.precondition = $0 },
        resetFunction: { _PA.precondition = nil }
    )
    
    static let assertionFailure: _AssertionConfig = _AssertionConfig(
        functionName: "assertionFailure()",
        patchFunction: { patch in _PA.assertionFailure = { patch({ false }, $0, $1, $2) } },
        resetFunction: { _PA.assertionFailure = nil }
    )
    
    static let preconditionFailure: _AssertionConfig = _AssertionConfig(
        functionName: "preconditionFailure()",
        patchFunction: { patch in _PA.preconditionFailure = { patch({ false }, $0, $1, $2); Swift.fatalError() } },
        resetFunction: { _PA.preconditionFailure = nil }
    )
    
    static let fatalError: _AssertionConfig = _AssertionConfig(
        functionName: "fatalError()",
        patchFunction: { patch in _PA.fatalError = { patch({ false }, $0, $1, $2); Swift.fatalError() } },
        resetFunction: { _PA.fatalError = nil }
    )
}


// MARK: - XCTestCase.Assertion
// MARK: _config extension
private extension XCTestCase.Assertion {
    var _config: _AssertionConfig {
        switch self {
        case .assert:               return .assert
        case .precondition:         return .precondition
        case .assertionFailure:     return .assertionFailure
        case .preconditionFailure:  return .preconditionFailure
        case .fatalError:           return .fatalError
        }
    }
}


// MARK: - XCTestCase
// MARK: expect... implementation
private extension XCTestCase {
    func _expect(_ assertion: Assertion, _ expectedMessage: String?, _ timeout: TimeInterval, _ testCase: @escaping _TestCase) {
        let assertionConfig: _AssertionConfig = assertion._config
        let assertionFunctionName: String = assertionConfig.functionName
        
        let expectation: XCTestExpectation = self.expectation(description: {
            guard let msg: String = expectedMessage else { return "Expected '\(assertionFunctionName)' to be called" }
            return "Expected '\(assertionFunctionName)' to be called with message '\(msg)'"
        }())
        
        let runForever: () -> Never = { repeat { RunLoop.main.run() } while (true) }
        
        assertionConfig.patchFunction({
            conditionClosure, messageClosure, _, _ in
            
            guard conditionClosure() == false else {
                XCTFail("'\(assertionFunctionName)' was called with a truthy condition")
                runForever()
            }
            
            let message: String = messageClosure()
            guard message == expectedMessage else {
                if let expectedMessage: String = expectedMessage {
                    XCTFail("'\(assertionFunctionName)' was called with message: \"\(message)\". Expected message '\(expectedMessage)'")
                } else {
                    XCTFail("'\(assertionFunctionName)' was called with message: \"\(message)\". Expected no message")
                }
                
                runForever()
            }
            
            assertionConfig.resetFunction()
            expectation.fulfill()
            
            runForever()
        })
        
        DispatchQueue.global(qos: .userInitiated).async(execute: testCase)
        
        self.waitForExpectations(timeout: timeout) { _ in
            assertionConfig.resetFunction()
        }
    }
}
