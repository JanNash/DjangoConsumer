//
//  JSONValueConvertible Tests.swift
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
class JSONValueConvertible_Tests: BaseTest {
    private class _Foo: JSONValueConvertible {
        init(_ inject: @escaping () -> Void) {
            self._inject = inject
        }
        
        private(set) var _inject: () -> Void
        
        let bar: String = "bar"
        
        func toJSONValue() -> Payload.JSON.Value {
            self._inject()
            return .string(self.bar)
        }
    }
    
    func testJSONValueConvertibleDefaultImplementationCallsToJSONValueWithDefaultConversion() {
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected Foo.toJSONValue to be called"
        )
        
        let foo: _Foo = _Foo(expectation.fulfill)
        
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
        
        XCTAssert(payloadElement.multipart.isEmpty)
        
        guard let json: Payload.JSON.UnwrappedPayload = payloadElement.json else {
            XCTFail("payloadElement does not contain json payload")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = ["baz": "bar"]
        
        XCTAssert(json == expectedJSON)
        
        self.waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testJSONValueConvertibleDefaultImplementationDoesNotCallToJSONValueWithCustomConversion() {
        struct _CustomConversion: PayloadConversion {
            func convert(_ jsonValueConvertible: JSONValueConvertible, configuration: Configuration) -> Payload.JSON.Value? {
                return .bool(false)
            }
        }
        
        let foo: _Foo = _Foo({
            XCTFail("toJSONValue should not be called")
        })
        
        let currentKey: String = "baz"
        
        let payloadElement: Payload.Element = foo.toPayloadElement(
            conversion: _CustomConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssert(payloadElement.multipart.isEmpty)
        
        guard let json: Payload.JSON.UnwrappedPayload = payloadElement.json else {
            XCTFail("payloadElement does not contain json payload")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = ["baz": false]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testProtocolExtensionResultEqualsDefaultImplementationResult() {
        typealias Dflt = DefaultImplementations.JSONValueConvertible
        
        let foo: _Foo = _Foo({})
        
        let currentKey: String = "baz"
        
        let conversion: PayloadConversion = DefaultPayloadConversion()
        let configuration: PayloadConversion.Configuration = (
            rootObject: nil,
            method: .get,
            multipartPath: Payload.Multipart.Path(currentKey),
            currentKey: currentKey
        )
        
        let payloadElementFromObject: Payload.Element = foo.toPayloadElement(
            conversion: conversion, configuration: configuration
        )
        
        let payloadElementFromDfltImpl: Payload.Element = Dflt.payloadElement(
            from: foo, conversion: (conversion, configuration)
        )
        
        guard let objectJSON: Payload.JSON.UnwrappedPayload = payloadElementFromObject.json else {
            XCTFail("payloadElementFromObject does not contain json payload")
            return
        }
        
        XCTAssert(objectJSON == ["baz": "bar"])
        
        guard let dfltImplJSON: Payload.JSON.UnwrappedPayload = payloadElementFromDfltImpl.json else {
            XCTFail("payloadElementFromDfltImpl does not contain json payload")
            return
        }
        
        XCTAssert(dfltImplJSON == ["baz": "bar"])
        
        XCTAssert(payloadElementFromObject.multipart == payloadElementFromDfltImpl.multipart)
    }
}
