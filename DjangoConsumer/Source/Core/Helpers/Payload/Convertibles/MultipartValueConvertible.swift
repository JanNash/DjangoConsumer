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
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
// MARK: PayloadValueConvertible Default Implementation
private extension MultipartValueConvertible {
    func _toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        if let multipartValue: Payload.Multipart.Value = conversion.convert(self, configuration: configuration) ?? self.toMultipartValue() {
            let resolvedPath: String = conversion.multipartKey(from: configuration)
            return (nil, [resolvedPath: multipartValue])
        }
        
        return ([configuration.currentKey: Payload.JSON.Value.null.unwrap()], nil)
    }
}
