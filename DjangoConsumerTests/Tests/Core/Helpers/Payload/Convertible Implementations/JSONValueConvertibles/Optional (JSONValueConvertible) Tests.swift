//
//  Optional (JSONValueConvertible) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
// All possible cases of Payload.JSON.Value:
/*
case bool(Bool?)
case int(Int?)
case int8(Int8?)
case int16(Int16?)
case int32(Int32?)
case int64(Int64?)
case uInt(UInt?)
case uInt8(UInt8?)
case uInt16(UInt16?)
case uInt32(UInt32?)
case uInt64(UInt64?)
case float(Float?)
case double(Double?)
case string(String?)
// Collections
case array([Value])
case dict([String: Value])
// Null
case null
 */


// MARK: -
class Optional_JSONValueConvertible_Tests: BaseTest {
    func testBoolNil() {
        let bool: Bool? = nil
        XCTAssertEqual(bool.toJSONValue(), .bool(nil))
    }
    
    func testBoolTrue() {
        let bool: Bool? = true
        XCTAssertEqual(bool.toJSONValue(), .bool(true))
    }
}
