//
//  Payload.JSON.Value.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 27.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: Interface
public extension Payload.JSON.Value {
    // Factories
    public static let null: Payload.JSON.Value = Payload.JSON.Value(.null)
    
    public static func bool(_ bool: Bool?) -> Payload.JSON.Value {
        return ._bool(bool)
    }
    
    public static func int<T>(_ int: T?) -> Payload.JSON.Value where T: SignedInteger {
        return ._int(int)
    }
    
    public static func uInt<T>(_ int: T?) -> Payload.JSON.Value where T: UnsignedInteger {
        return ._uInt(int)
    }
    
    public static func float<T>(_ float: T?) -> Payload.JSON.Value where T: BinaryFloatingPoint {
        return ._float(float)
    }
    
    public static func string(_ string: String?) -> Payload.JSON.Value {
        return ._string(string)
    }
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
extension Payload.JSON.Value: CustomStringConvertible {
    public var description: String {
        return self._description
    }
}


// MARK: // Internal
// MARK: Interface
extension Payload.JSON.Value {
    func unwrap() -> Any {
        return self._unwrap()
    }
}


// MARK: // Private
// MARK: Interface Implementations
private extension Payload.JSON.Value {
    static func _bool(_ bool: Bool?) -> Payload.JSON.Value {
        return Payload.JSON.Value(.bool(bool))
    }
    
    static func _int<T>(_ int: T?) -> Payload.JSON.Value where T: SignedInteger {
        guard let int: T = int else {
            return Payload.JSON.Value(.int(nil))
        }
        return Payload.JSON.Value(.int(Int(int)))
    }
    
    static func _uInt<T>(_ uInt: T?) -> Payload.JSON.Value where T: UnsignedInteger {
        guard let uInt: T = uInt else {
            return Payload.JSON.Value(.uInt(nil))
        }
        return Payload.JSON.Value(.uInt(UInt(uInt)))
    }
    
    static func _float<T>(_ float: Optional<T>) -> Payload.JSON.Value where T: BinaryFloatingPoint {
        if let float: T = float {
            guard !float.isNaN, float.isFinite else {
                return Payload.JSON.Value(.float(nil))
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
        
        return Payload.JSON.Value(.float(double))
    }
    
    static func _string(_ string: String?) -> Payload.JSON.Value {
        return Payload.JSON.Value(.string(string))
    }
    
    func _unwrap() -> Any {
        return {
            switch self.typedValue {
            case .null:                 return nil
            case .bool(let value):      return value
            case .int(let value):       return value
            case .uInt(let value):      return value
            case .float(let value):     return value
            case .string(let value):    return value
            }
        }() ?? NSNull() as Any
    }
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
private extension Payload.JSON.Value/*: CustomStringConvertible*/ {
    var _description: String {
        switch self.typedValue {
        case .null:                 return ".null"
        case .bool(let value):      return ".bool(\(self._describeValue(value)))"
        case .int(let value):       return ".int(\(self._describeValue(value)))"
        case .uInt(let value):      return ".uInt(\(self._describeValue(value)))"
        case .float(let value):     return ".float(\(self._describeValue(value)))"
        case .string(let value):    return ".string(\(self._describeValue(value)))"
        }
    }
    
    func _describeValue(_ value: Any?) -> String {
        return (value as? CustomStringConvertible)?.description ?? "null"
    }
}
