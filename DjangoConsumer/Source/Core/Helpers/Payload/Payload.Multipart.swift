//
//  Payload.Multipart.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 23.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: -
public extension Payload.Multipart {
    static func value(_ data: Data?, _ contentType: ContentType) -> Value {
        return self._value(data, contentType)
    }
}

// Put MultipartOptional into Payload.Multipart as Payload.Multipart.Optional


// MARK: // Public
// MARK: Struct Declaration
public struct MultipartOptional<V: MultipartValueConvertible> {
    // Init
    public init(_ value: V?) {
        self._value = value
    }
    
    // Private Constants
    private let _value: V?
}


// MARK: Protocol Conformances
// MARK: PayloadElementConvertible
extension MultipartOptional: PayloadElementConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
// MARK: Protocol Conformance Implementations
// MARK: PayloadElementConvertible
private extension MultipartOptional/*: PayloadElementConvertible*/ {
    func _toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        switch self._value {
        case .some(let value):
            return value.toPayloadElement(conversion: conversion, configuration: configuration)
        case .none:
            return DefaultImplementations.JSONValueConvertible.payloadElement(
                from: Payload.JSON.Value.null, conversion: (conversion, configuration)
            )
        }
    }
}


// MARK: // Private
private extension Payload.Multipart {
    static func _value(_ data: Data?, _ contentType: ContentType) -> Value {
        if let data: Data = data {
            return (data, contentType)
        } else {
            return contentType.null
        }
    }
}
