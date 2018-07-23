//
//  MultipartValueConvertible.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: Public
// MARK: -
public protocol MultipartValueConvertible: PayloadElementConvertible {
    func toMultipartValue() -> Payload.Multipart.Value
}


// MARK: PayloadValueConvertible Default Implementation
public extension MultipartValueConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return DefaultImplementations.MultipartValueConvertible.payloadElement(from: self, conversion: (conversion, configuration))
    }
}


// MARK: - DefaultImplementations.MultipartValueConvertible
public extension DefaultImplementations.MultipartValueConvertible {
    public static func payloadElement(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        return self._payloadElement(from: convertible, conversion: conversion)
    }
    
    public static func multipartPayload(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Multipart.UnwrappedPayload? {
        return self._multipartPayload(from: convertible, conversion: conversion)
    }
}



// MARK: // Private
private extension DefaultImplementations.MultipartValueConvertible {
    private static func _payloadElement(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        if let multipartPayload: Payload.Multipart.UnwrappedPayload = self.multipartPayload(from: convertible, conversion: conversion) {
            return (nil, multipartPayload)
        }
        
        return DefaultImplementations.JSONValueConvertible.payloadElement(
            from: Payload.JSON.Value.null, conversion: conversion
        )
    }
    
    private static func _multipartPayload(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Multipart.UnwrappedPayload? {
        let (conv, conf): (PayloadConversion, PayloadConversion.Configuration) = conversion
        let multipartValue: Payload.Multipart.Value = {
            conv.convert(convertible, configuration: conf) ?? convertible.toMultipartValue()
        }()
        
        // This is quite hacky but I haven't found a better way yet.
        if multipartValue == multipartValue.1.null {
            switch conf.multipartPath.tail.last {
            case .some(.key), .none:
                return nil
            case .some(.index):
                break
            }
        }
        
        let resolvedPath: String = conv.multipartKey(from: conf)
        return [resolvedPath: multipartValue]
    }
}
