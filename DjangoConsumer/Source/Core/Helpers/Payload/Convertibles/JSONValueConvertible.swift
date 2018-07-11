//
//  JSONValueConvertible.swift
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
// MARK: -
public protocol JSONValueConvertible: PayloadElementConvertible {
    func toJSONValue() -> Payload.JSON.Value
}


// MARK: PayloadValueConvertible Default Implementation
public extension JSONValueConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
// MARK: PayloadValueConvertible Default Implementation
private extension JSONValueConvertible {
    func _toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        let jsonValue: Payload.JSON.Value = conversion.convert(self, configuration: configuration) ?? self.toJSONValue()
        return ([configuration.currentKey: jsonValue.unwrap()], nil)
    }
}
