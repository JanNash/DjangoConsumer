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


// MARK: // Internal
// MARK: Interface
extension Payload.JSON.Value {
    func unwrap() -> Any {
        return self._unwrap()
    }
    
    func toMultipartValue() -> Payload.Multipart.Value {
        return self._toMultipartValue()
    }
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
extension Payload.JSON.Value/*: CustomStringConvertible*/ {
    public var description: String {
        return self._description
    }
}


// MARK: // Private
// MARK: Interface Implementations
private extension Payload.JSON.Value {
    func _unwrap() -> Any {
        return {
            // Is there a way to do this in a generic manner?
            // When checking cases like this:
            // switch self {
            //     case .bool(let v), .int(let v), .int8(let v), ...
            // the compiler complains about the different types.
            // Also, it won't allow casting to Any inside the variable
            // binding like that: case .bool(let v as Any)
            switch self {
            case .bool(let v):      return v
            case .int(let v):       return v
            case .int8(let v):      return v
            case .int16(let v):     return v
            case .int32(let v):     return v
            case .int64(let v):     return v
            case .uInt(let v):      return v
            case .uInt8(let v):     return v
            case .uInt16(let v):    return v
            case .uInt32(let v):    return v
            case .uInt64(let v):    return v
            case .float(let v):     return v
            case .double(let v):    return v
            case .string(let v):    return v
            case .array(let v):     return v.map({ $0.unwrap() })
            case .dict(let v):      return v.mapValues({ $0.unwrap() })
            case .null:             return nil
            }
        }() ?? NSNull() as Any
    }
    
    func _toMultipartValue() -> Payload.Multipart.Value {
        switch self {
        case .array, .dict:
            return (try! JSONSerialization.data(withJSONObject: self.unwrap()), .applicationJSON)
        case .null:
            return Payload.Multipart.ContentType.applicationJSON.null
        default:
            return ("\(self.unwrap())".data(using: .utf8)!, .applicationJSON)
        }
    }
}


// MARK: Protocol Conformances
// MARK: CustomStringConvertible
private extension Payload.JSON.Value/*: CustomStringConvertible*/ {
    var _description: String {
        let d: (Any?) -> String = self._describe
        switch self {
        case .bool(let v):      return ".bool("   + "\(d(v)))"
        case .int(let v):       return ".int("    + "\(d(v)))"
        case .int8(let v):      return ".int8("   + "\(d(v)))"
        case .int16(let v):     return ".int16("  + "\(d(v)))"
        case .int32(let v):     return ".int32("  + "\(d(v)))"
        case .int64(let v):     return ".int64("  + "\(d(v)))"
        case .uInt(let v):      return ".uInt("   + "\(d(v)))"
        case .uInt8(let v):     return ".uInt8("  + "\(d(v)))"
        case .uInt16(let v):    return ".uInt16(" + "\(d(v)))"
        case .uInt32(let v):    return ".uInt32(" + "\(d(v)))"
        case .uInt64(let v):    return ".uInt64(" + "\(d(v)))"
        case .float(let v):     return ".float("  + "\(d(v)))"
        case .double(let v):    return ".double(" + "\(d(v)))"
        case .string(let v):    return ".string(" + "\(d(v)))"
        case .array(let v):     return ".array("  + "\(d(v))"
        case .dict(let v):      return ".dict("   + "\(d(v))"
        case .null:             return ".null"
        }
    }
    
    func _describe(_ value: Any?) -> String {
        return (value as? CustomStringConvertible)?.description ?? "null"
    }
}
