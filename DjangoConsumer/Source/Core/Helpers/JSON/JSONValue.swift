//
//  JSONValue.swift
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
// MARK: Interface
public extension JSONValue {
    public static let null: JSONValue = JSONValue(.null)
    
    public static func bool(_ bool: Bool?) -> JSONValue {
        return ._bool(bool)
    }
    
    public static func int<T>(_ int: T?) -> JSONValue where T: SignedInteger {
        return ._int(int)
    }
    
    public static func uInt<T>(_ int: T?) -> JSONValue where T: UnsignedInteger {
        return ._uInt(int)
    }
    
    public static func float<T>(_ float: T?) -> JSONValue where T: BinaryFloatingPoint {
        return ._float(float)
    }
    
    public static func string(_ string: String?) -> JSONValue {
        return ._string(string)
    }
    
    public static func array(_ array: [JSONValueConvertible]?) -> JSONValue {
        return ._array(array)
    }
    
    public static func dict(_ dict: JSONDict?) -> JSONValue {
        return ._dict(dict)
    }
    
    public static func dict(_ dict: [String: JSONValueConvertible]?) -> JSONValue {
        return ._dict(dict)
    }
    
    public static func dict(_ jsonConvertible: JSONConvertible?) -> JSONValue {
        return ._dict(jsonConvertible)
    }
}


// MARK: Struct Declaration
public struct JSONValue {
    // ValueType
    indirect enum ValueType {
        case null
        case bool(Bool?)
        case int(Int?)
        case uInt(UInt?)
        case float(Double?)
        case string(String?)
        case array([JSONValue]?)
        case dict(JSONDict?)
    }
    
    // Private Init
    private init(_ typedValue: ValueType) {
        self.typedValue = typedValue
    }
    
    // Value
    let typedValue: ValueType
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
extension JSONValue: CustomStringConvertible {
    public var description: String {
        return self._description
    }
}


// MARK: // Internal
// MARK: Interface
extension JSONValue {
    static func unwrap(_ jsonValue: JSONValue) -> Any? {
        return self._unwrap(jsonValue)
    }
}


// MARK: // Private
// MARK: Interface Implementations
private extension JSONValue {
    static func _bool(_ bool: Bool?) -> JSONValue {
        return JSONValue(.bool(bool))
    }
    
    static func _int<T>(_ int: T?) -> JSONValue where T: SignedInteger {
        guard let int: T = int else {
            return JSONValue(.int(nil))
        }
        return JSONValue(.int(Int(int)))
    }
    
    static func _uInt<T>(_ uInt: T?) -> JSONValue where T: UnsignedInteger {
        guard let uInt: T = uInt else {
            return JSONValue(.uInt(nil))
        }
        return JSONValue(.uInt(UInt(uInt)))
    }
    
    static func _float<T>(_ float: Optional<T>) -> JSONValue where T: BinaryFloatingPoint {
        if let float: T = float {
            guard !float.isNaN, float.isFinite else {
                return JSONValue(.float(nil))
            }
        }
        
        var double: Double?
        if let f: Float = float as? Float {
            double = Double(f)
        } else if let f32: Float32 = float as? Float32 {
            double = Double(f32)
        } else if let f64: Float64 = float as? Float64 {
            double = Double(f64)
        } else if let cg: CGFloat = float as? CGFloat {
            double = Double(cg)
        }
        
        return JSONValue(.float(double))
    }
    
    static func _string(_ string: String?) -> JSONValue {
        return JSONValue(.string(string))
    }
    
    static func _array(_ array: [JSONValueConvertible]?) -> JSONValue {
        return JSONValue(.array(array?.map({ $0.toJSONValue() })))
    }
    
    static func _dict(_ dict: JSONDict?) -> JSONValue {
        return JSONValue(.dict(dict))
    }
    
    static func _dict(_ dict: [String: JSONValueConvertible]?) -> JSONValue {
        guard let dict: [String: JSONValueConvertible] = dict else { return JSONValue(.dict(nil)) }
        return .dict(JSONDict(dict))
    }
    
    static func _dict(_ jsonConvertible: JSONConvertible?) -> JSONValue {
        return .dict(jsonConvertible?.jsonDict())
    }
    
    static func _unwrap(_ jsonValue: JSONValue) -> Any? {
        switch jsonValue.typedValue {
        case .null:                 return nil
        case .bool(let value):      return value
        case .int(let value):       return value
        case .uInt(let value):      return value
        case .float(let value):     return value
        case .string(let value):    return value
        case .array(let value):     return value?.map(JSONValue.unwrap)
        case .dict(let value):      return value?.unwrap()
        }
    }
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
private extension JSONValue/*: CustomStringConvertible*/ {
    var _description: String {
        switch self.typedValue {
        case .null:                 return ".null"
        case .bool(let value):      return ".bool(\(self._describeValue(value)))"
        case .int(let value):       return ".int(\(self._describeValue(value)))"
        case .uInt(let value):      return ".uInt(\(self._describeValue(value)))"
        case .float(let value):     return ".float(\(self._describeValue(value)))"
        case .string(let value):    return ".string(\(self._describeValue(value)))"
        case .array(let value):     return ".array(\(self._describeValue(value)))"
        case .dict(let value):      return ".dict(\(self._describeValue(value?.dict)))"
        }
    }
    
    func _describeValue(_ value: Any?) -> String {
        return (value as? CustomStringConvertible)?.description ?? "null"
    }
}
