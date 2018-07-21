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
    func toMultipartValue() -> Payload.Multipart.Value?
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
}



// MARK: // Private
private extension DefaultImplementations.MultipartValueConvertible {
    static func _payloadElement(from convertible: MultipartValueConvertible, conversion: (PayloadConversion, PayloadConversion.Configuration)) -> Payload.Element {
        let (conversion, configuration): (PayloadConversion, PayloadConversion.Configuration) = conversion
        if let multipartValue: Payload.Multipart.Value =
            conversion.convert(convertible, configuration: configuration)
                ?? convertible.toMultipartValue()
        {
            let resolvedPath: String = conversion.multipartKey(from: configuration)
            return (nil, [resolvedPath: multipartValue])
        }
        
        return ([configuration.currentKey: Payload.JSON.Value.null.unwrap()], nil)
    }
}
