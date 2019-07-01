//
//  ProgrammerAssertionTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: // Internal
class ProgrammerAssertionTests: BaseTest {
    func testAssert() {
        let message: String = "Foobar!"
        
        self.expect(.assert, expectedMessage: message, timeout: 100, {
            DjangoConsumer.assert(false, message)
        })
    }
    
    func testPrecondition() {
        let message: String = "Foobar!"
        
        self.expect(.precondition, expectedMessage: message, timeout: 100, {
            DjangoConsumer.precondition(false, message)
        })
    }
    
    func testAssertionFailure() {
        let message: String = "Foobar!"
        
        self.expect(.assertionFailure, expectedMessage: message, timeout: 100, {
            DjangoConsumer.assertionFailure(message)
        })
    }
    
    func testPreconditionFailure() {
        let message: String = "Foobar!"
        
        self.expect(.preconditionFailure, expectedMessage: message, timeout: 100, {
            DjangoConsumer.preconditionFailure(message)
        })
    }
    
    func testFatalError() {
        let message: String = "Foobar!"
        
        self.expect(.fatalError, expectedMessage: message, timeout: 100, {
            DjangoConsumer.fatalError(message)
        })
    }
}
