//
//  Optional (PayloadElementConvertible) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 28.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: -
class Optional_PayloadElementConvertible_Tests: BaseTest {
    // No optional chaining needs to be used here since this is an extension on Optional itself
    func testOptionalMultipartValueConvertibleWithNilValue() {
        let currentKey: String = "foo"
        
        let imageOptional: UIImage? = nil
        
        let payloadElement: Payload.Element = imageOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalMultipartValueConvertibleWithSomeValue() {
        let currentKey: String = "foo"
        
        let imageOptional: UIImage? = UIImage(color: .red)
        
        let payloadElement: Payload.Element = imageOptional.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssertNil(payloadElement.json)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "foo": (UIImage(color: .red).pngData()!, .imagePNG)
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
    
    func testOptionalBoolNil() {
        let currentKey: String = "foo"
        
        let boolOptional: Bool? = nil
        
        let payloadElement: Payload.Element = boolOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalBoolTrue() {
        let currentKey: String = "foo"
        
        let boolOptional: Bool? = true
        
        let payloadElement: Payload.Element = boolOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: true]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalBoolFalse() {
        let currentKey: String = "foo"
        
        let boolOptional: Bool? = false
        
        let payloadElement: Payload.Element = boolOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: false]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalIntWithNilValue() {
        let currentKey: String = "foo"
        
        let intOptional: Int? = nil
        
        let payloadElement: Payload.Element = intOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalIntWithSomeValues() {
        let currentKey: String = "foo"
        
        let tenToThePowerOfTwelve: Int = 1_000_000_000_000
        let range: Range<Int> = -tenToThePowerOfTwelve..<tenToThePowerOfTwelve
        for _ in 0..<1000 {
            let _int: Int = .random(in: range)
            let someInt: Int? = _int
            
            let payloadElement: Payload.Element = someInt.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _int]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalInt8WithNilValue() {
        let currentKey: String = "foo"
        
        let int8Optional: Int8? = nil
        
        let payloadElement: Payload.Element = int8Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalInt8WithSomeValues() {
        let currentKey: String = "foo"
        
        let aHundred: Int8 = 100
        let range: Range<Int8> = -aHundred..<aHundred
        for _ in 0..<1000 {
            let _int8: Int8 = .random(in: range)
            let someInt8: Int8? = _int8
            
            let payloadElement: Payload.Element = someInt8.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _int8]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalInt16WithNilValue() {
        let currentKey: String = "foo"
        
        let int16Optional: Int16? = nil
        
        let payloadElement: Payload.Element = int16Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalInt16WithSomeValues() {
        let currentKey: String = "foo"
        
        let aThousand: Int16 = 1000
        let range: Range<Int16> = -aThousand..<aThousand
        for _ in 0..<1000 {
            let _int16: Int16 = .random(in: range)
            let someInt16: Int16? = _int16
            
            let payloadElement: Payload.Element = someInt16.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _int16]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalInt32WithNilValue() {
        let currentKey: String = "foo"
        
        let int32Optional: Int32? = nil
        
        let payloadElement: Payload.Element = int32Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalInt32WithSomeValues() {
        let currentKey: String = "foo"
        
        let aMillion: Int32 = 1_000_000
        let range: Range<Int32> = -aMillion..<aMillion
        for _ in 0..<1000 {
            let _int32: Int32 = .random(in: range)
            let someInt32: Int32? = _int32
            
            let payloadElement: Payload.Element = someInt32.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _int32]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalInt64WithNilValue() {
        let currentKey: String = "foo"
        
        let int64Optional: Int64? = nil
        
        let payloadElement: Payload.Element = int64Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalInt64WithSomeValues() {
        let currentKey: String = "foo"
        
        let tenToThePowerOfTwelve: Int64 = 1_000_000_000_000
        let range: Range<Int64> = -tenToThePowerOfTwelve..<tenToThePowerOfTwelve
        for _ in 0..<1000 {
            let _int64: Int64 = .random(in: range)
            let someInt64: Int64? = _int64
            
            let payloadElement: Payload.Element = someInt64.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _int64]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalUIntWithNilValue() {
        let currentKey: String = "foo"
        
        let uIntOptional: UInt? = nil
        
        let payloadElement: Payload.Element = uIntOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalUIntWithSomeValues() {
        let currentKey: String = "foo"
        
        let range: Range<UInt> = 0..<1_000_000_000_000_000_000
        for _ in 0..<1000 {
            let _uInt: UInt = .random(in: range)
            let someUInt: UInt? = _uInt
            
            let payloadElement: Payload.Element = someUInt.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _uInt]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalUInt8WithNilValue() {
        let currentKey: String = "foo"
        
        let uInt8Optional: UInt8? = nil
        
        let payloadElement: Payload.Element = uInt8Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalUInt8WithSomeValues() {
        let currentKey: String = "foo"
        
        let range: Range<UInt8> = 0..<100
        for _ in 0..<1000 {
            let _uInt8: UInt8 = .random(in: range)
            let someUInt8: UInt8? = _uInt8
            
            let payloadElement: Payload.Element = someUInt8.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _uInt8]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalUInt16WithNilValue() {
        let currentKey: String = "foo"
        
        let uInt16Optional: UInt16? = nil
        
        let payloadElement: Payload.Element = uInt16Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalUInt16WithSomeValues() {
        let currentKey: String = "foo"
        
        let range: Range<UInt16> = 0..<10_000
        for _ in 0..<1000 {
            let _uInt16: UInt16 = .random(in: range)
            let someUInt16: UInt16? = _uInt16
            
            let payloadElement: Payload.Element = someUInt16.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _uInt16]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalUInt32WithNilValue() {
        let currentKey: String = "foo"
        
        let uInt32Optional: UInt32? = nil
        
        let payloadElement: Payload.Element = uInt32Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalUInt32WithSomeValues() {
        let currentKey: String = "foo"
        
        let range: Range<UInt32> = 0..<1_000_000_000
        for _ in 0..<1000 {
            let _uInt32: UInt32 = .random(in: range)
            let someUInt32: UInt32? = _uInt32
            
            let payloadElement: Payload.Element = someUInt32.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _uInt32]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalUInt64WithNilValue() {
        let currentKey: String = "foo"
        
        let uInt64Optional: UInt64? = nil
        
        let payloadElement: Payload.Element = uInt64Optional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalUInt64WithSomeValues() {
        let currentKey: String = "foo"
        
        let range: Range<UInt64> = 0..<10_000_000_000_000_000_000
        for _ in 0..<1000 {
            let _uInt64: UInt64 = .random(in: range)
            let someUInt64: UInt64? = _uInt64
            
            let payloadElement: Payload.Element = someUInt64.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _uInt64]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalFloatWithNilValue() {
        let currentKey: String = "foo"
        
        let floatOptional: Float? = nil
        
        let payloadElement: Payload.Element = floatOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalFloatWithSomeValues() {
        let currentKey: String = "foo"
        
        let tenToThePowerOfNine: Float = 1_000_000_000
        let range: Range<Float> = -tenToThePowerOfNine..<tenToThePowerOfNine
        for _ in 0..<1000 {
            let _float: Float = .random(in: range)
            let someFloat: Float? = _float
            
            let payloadElement: Payload.Element = someFloat.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _float]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalDoubleWithNilValue() {
        let currentKey: String = "foo"
        
        let doubleOptional: Double? = nil
        
        let payloadElement: Payload.Element = doubleOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalDoubleWithSomeValues() {
        let currentKey: String = "foo"
        
        let tenToThePowerOfTwelve: Double = 1_000_000_000_000
        let range: Range<Double> = -tenToThePowerOfTwelve..<tenToThePowerOfTwelve
        for _ in 0..<1000 {
            let _double: Double = .random(in: range)
            let someDouble: Double? = _double
            
            let payloadElement: Payload.Element = someDouble.toPayloadElement(
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
                XCTFail("payloadElement must contain json")
                return
            }
            
            let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: _double]
            
            XCTAssert(json == expectedJSON)
        }
    }
    
    func testOptionalStringWithNilValue() {
        let currentKey: String = "foo"
        
        let stringOptional: String? = nil
        
        let payloadElement: Payload.Element = stringOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalStringWithSomeValues() {
        let currentKey: String = "foo"
        
        let strng: String = "bar"
        let stringOptional: String? = strng
        
        let payloadElement: Payload.Element = stringOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: strng]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalDateWithNilValue() {
        let currentKey: String = "foo"
        
        let dateOptional: Date? = nil
        
        let payloadElement: Payload.Element = dateOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalDateWithSomeValue() {
        let currentKey: String = "foo"
        
        let date: Date = Date()
        let dateOptional: Date? = date
        
        let payloadElement: Payload.Element = dateOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedDateString: String = {
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return formatter.string(from: date)
        }()
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [currentKey: expectedDateString]
        
        XCTAssert(json == expectedJSON)
    }
}
