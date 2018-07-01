//
//  Optional (JSONValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 01.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Optional: JSONValueConvertible where Wrapped: JSONValueConvertible {
    public func toJSONValue() -> Payload.JSON.Value {
        return self._toJSONValue()
    }
}


// MARK: // Private
private extension Optional where Wrapped: JSONValueConvertible {
    func _toJSONValue() -> Payload.JSON.Value {
        switch self {
        case .some(let value):      return value.toJSONValue()
        case .none:
            switch Wrapped.self {
            case _ as Bool.Type:    return .bool(nil as Bool?)
            case _ as Int.Type:     return .int(nil as Int?)
            case _ as Int8.Type:    return .int8(nil as Int8?)
            case _ as Int16.Type:   return .int16(nil as Int16?)
            case _ as Int32.Type:   return .int32(nil as Int32?)
            case _ as Int64.Type:   return .int64(nil as Int64?)
            case _ as UInt.Type:    return .uInt(nil as UInt?)
            case _ as UInt8.Type:   return .uInt8(nil as UInt8?)
            case _ as UInt16.Type:  return .uInt16(nil as UInt16?)
            case _ as UInt32.Type:  return .uInt32(nil as UInt32?)
            case _ as UInt64.Type:  return .uInt64(nil as UInt64?)
            case _ as Float.Type:   return .float(nil as Float?)
            case _ as Double.Type:  return .double(nil as Double?)
            case _ as String.Type:  return .string(nil as String?)
            default:                return .null
            }
        }
    }
}
