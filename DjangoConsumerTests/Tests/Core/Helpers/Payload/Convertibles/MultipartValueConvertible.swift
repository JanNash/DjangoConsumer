//
//  MultipartValueConvertible.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 01.05.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class MultipartValueConvertible_Tests: BaseTest {
    private class _Foo: MultipartValueConvertible {
        init(_ inject: @escaping () -> Payload.Multipart.Value) {
            self._inject = inject
        }
        
        private(set) var _inject: () -> Payload.Multipart.Value
        
        func toMultipartValue() -> Payload.Multipart.Value {
            return self._inject()
        }
    }
    
    struct _CustomConversion: PayloadConversion {
        let inject: () -> Payload.Multipart.Value?
        
        func convert(_ multipartValueConvertible: MultipartValueConvertible, configuration: Configuration) -> Payload.Multipart.Value? {
            return self.inject()
        }
    }
    
    func test_MultipartValueConvertible_DefaultImplementation_Calls_ToMultipartValue_With_DefaultPayloadConversion() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected Foo.toMultipartValue to be called"
        )
        
        let multipartValue: Payload.Multipart.Value = ("bar".data(using: .utf8)!, .applicationJSON)
        
        let foo: _Foo = _Foo({
            expectation.fulfill()
            return multipartValue
        })
        
        let currentKey: String = "baz"
        
        let payloadElement: Payload.Element = foo.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssertNil(payloadElement.json)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = ["baz": multipartValue]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
        
        self.waitForExpectations(timeout: 100)
    }
    
    func test_MultipartValueConvertible_DefaultImplementation_DoesNotCall_ToMultipartValue_With_CustomPayloadConversion() {
        let multipartValue: Payload.Multipart.Value = ("bar".data(using: .utf8)!, .applicationJSON)
        
        let foo: _Foo = _Foo({
            XCTFail("toMultipartValue should not be called")
            return multipartValue
        })
        
        let currentKey: String = "baz"
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected _CustomConversion.convert(_:_:) -> Payload.Multipart.UnwrappedPayload to be called"
        )
        
        let payloadElement: Payload.Element = foo.toPayloadElement(
            conversion: _CustomConversion(inject: {
                expectation.fulfill()
                return multipartValue
            }),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssertNil(payloadElement.json)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = ["baz": multipartValue]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
        
        self.waitForExpectations(timeout: 100)
    }
    
    func test_ProtocolExtension_Result_Equals_DefaultImplementationResult() {
        typealias Closure = () -> Payload.Element
        
        let multipartValue: Payload.Multipart.Value = ("bar".data(using: .utf8)!, .applicationJSON)
        
        let foo: _Foo = _Foo({
            XCTFail("_Foo.toMultipartValue() should not be called")
            return multipartValue
        })
        
        let expectation: XCTestExpectation = {
            let description: String =
                "Expected exactly two calls to _CustomConversion.convert(_:_:) -> Payload.Multipart.UnwrappedPayload"
            let exp: XCTestExpectation = self.expectation(description: description)
            exp.expectedFulfillmentCount = 2
            return exp
        }()
        
        let conversion: PayloadConversion = _CustomConversion(inject: {
            expectation.fulfill()
            return multipartValue
        })
        
        let currentKey: String = "baz"
        let configuration: PayloadConversion.Configuration = (
            rootObject: nil,
            method: .get,
            multipartPath: Payload.Multipart.Path(currentKey),
            currentKey: currentKey
        )
        
        let protocolExtImpl: Closure = {
            foo.toPayloadElement(conversion: conversion, configuration: configuration)
        }
        
        let defaultImpl: () -> Payload.Element = {
            DefaultImplementations.MultipartValueConvertible.payloadElement(
                from: foo, conversion: (conversion, configuration)
            )
        }
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = ["baz": multipartValue]
        
        [protocolExtImpl, defaultImpl].forEach({
            let element: Payload.Element = $0()
            XCTAssertNil(element.json)
            XCTAssert(element.multipart == expectedMultipart)
        })
        
        self.waitForExpectations(timeout: 100)
    }
    
    func test_MultipartValueConvertible_DefaultImplementation_With() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected Foo.toMultipartValue to be called"
        )
        
        let multipartValue: Payload.Multipart.Value = ("bar".data(using: .utf8)!, .applicationJSON)
        
        let foo: _Foo = _Foo({
            expectation.fulfill()
            return multipartValue
        })
        
        let currentKey: String = "baz"
        
        let payloadElement: Payload.Element = foo.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssertNil(payloadElement.json)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = ["baz": multipartValue]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
        
        self.waitForExpectations(timeout: 100)
    }
}
