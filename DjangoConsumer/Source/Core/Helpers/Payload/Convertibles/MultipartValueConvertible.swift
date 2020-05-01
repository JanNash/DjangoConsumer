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
    func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return DefaultImplementations.MultipartValueConvertible.payloadElement(from: self, conversion: (conversion, configuration))
    }
}


// MARK: - DefaultImplementations.MultipartValueConvertible
public extension DefaultImplementations.MultipartValueConvertible {
    static func payloadElement(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        return self._payloadElement(from: convertible, conversion: conversion)
    }
    
    static func multipartPayload(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Multipart.UnwrappedPayload? {
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
        let multipartValue: Payload.Multipart.Value =
            conv.convert(convertible, configuration: conf) ?? convertible.toMultipartValue()
        
        // This is quite hacky but I haven't found a better way yet.
        // It is done so an empty multipart value (multipartValue.1.null)
        // that is part of an array (.some(.index)) is returned as multipart,
        // so the whole array is included in the multipart instead of it
        // being split between the json payload and the multipart payload
        // which might make the order of the array undefined.
        // If the empty multipart value however is a single value in a
        // dictionary (.some(.key)) or the multipartPath tail is empty,
        // this function returns nil, which leads to the above function
        // returning a JSON null value instead of multipart in its payloadElement.
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
