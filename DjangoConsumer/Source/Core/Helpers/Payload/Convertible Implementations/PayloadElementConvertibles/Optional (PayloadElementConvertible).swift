//
//  Optional (PayloadElementConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Optional: PayloadElementConvertible where Wrapped: PayloadElementConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
private extension Optional where Wrapped: PayloadElementConvertible {
    func _toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        switch self {
        case .some(let convertible):
            return convertible.toPayloadElement(conversion: conversion, configuration: configuration)
        case .none:
            let jsonValue: Payload.JSON.Value = {
                // This was formerly inside the conditional JSONValueConvertible conformance
                // implementation of Optional. I'm not sure but I think it was only really
                // needed for cosmetic reasons when printing Payload.JSON.Values.
                // Will keep it here just in case.
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
            }()
            return DefaultImplementations.JSONValueConvertible.payloadElement(
                from: jsonValue, conversion: (conversion, configuration)
            )
        }
    }
}
