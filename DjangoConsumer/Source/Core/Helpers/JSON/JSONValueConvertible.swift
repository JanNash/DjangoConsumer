//
//  JSONValueConvertible.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.05.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: Protocol Declaration
public protocol JSONValueConvertible {
    func toJSONValue() -> JSONValue
}


// MARK: JSONValueConvertible
extension JSONValue: JSONValueConvertible {
    public func toJSONValue() -> JSONValue { return self }
}


// MARK: Native JSON types
// MARK: Bool
extension Bool: JSONValueConvertible {
    public func toJSONValue() -> JSONValue { return .bool(self) }
}


// MARK: Float
extension Numeric where Self: BinaryFloatingPoint {
    public func toJSONValue() -> JSONValue { return .float(self) }
}

extension Float: JSONValueConvertible {}
extension Double: JSONValueConvertible {}
extension CGFloat: JSONValueConvertible {}


// MARK: Int
extension Numeric where Self: BinaryInteger {
    public func toJSONValue() -> JSONValue { return .int(self) }
}

extension Int: JSONValueConvertible {}
extension Int8: JSONValueConvertible {}
extension Int16: JSONValueConvertible {}
extension Int32: JSONValueConvertible {}
extension Int64: JSONValueConvertible {}
extension UInt: JSONValueConvertible {}
extension UInt8: JSONValueConvertible {}
extension UInt16: JSONValueConvertible {}
extension UInt32: JSONValueConvertible {}
extension UInt64: JSONValueConvertible {}


// MARK: String
extension String: JSONValueConvertible {
    public func toJSONValue() -> JSONValue { return .string(self) }
}


// MARK: Optional
extension Optional: JSONValueConvertible where Wrapped: JSONValueConvertible {
    public func toJSONValue() -> JSONValue { return self._toJSONValue() }
}


// MARK: Conditional Conformances
//extension Dictionary: JSONValueConvertible where Key == String, Value: JSONValueConvertible {
//    public func toJSONValue() -> JSONValue { return .dict(self) }
//}

//extension Array: JSONValueConvertible where Element: JSONValueConvertible {
//    public func toJSONValue() -> JSONValue { return .array(self) }
//}


// MARK: // Private
// MARK: Optional
private extension Optional/*: JSONValueConvertible*/ where Wrapped: JSONValueConvertible {
    func _toJSONValue() -> JSONValue {
        switch self {
        case .some(let value):  return value.toJSONValue()
        case .none:
            switch Wrapped.self {
            case _ as Bool.Type:    return .bool(nil)
            case _ as Float.Type:   return .float(nil as Float?)
            case _ as Double.Type:  return .float(nil as Double?)
            case _ as CGFloat.Type: return .float(nil as CGFloat?)
            case _ as Int.Type:     return .int(nil as Int?)
            case _ as Int8.Type:    return .int(nil as Int8?)
            case _ as Int16.Type:   return .int(nil as Int16?)
            case _ as Int32.Type:   return .int(nil as Int32?)
            case _ as Int64.Type:   return .int(nil as Int64?)
            case _ as UInt.Type:    return .int(nil as UInt?)
            case _ as UInt8.Type:   return .int(nil as UInt8?)
            case _ as UInt16.Type:  return .int(nil as UInt16?)
            case _ as UInt32.Type:  return .int(nil as UInt32?)
            case _ as UInt64.Type:  return .int(nil as UInt64?)
            case _ as String.Type:  return .string(nil)
            default:                return .null
            }
        }
    }
}
