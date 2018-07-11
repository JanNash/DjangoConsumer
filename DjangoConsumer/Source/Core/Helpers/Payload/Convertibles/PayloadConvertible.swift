//
//  PayloadConvertible.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


public protocol PayloadConversion {
    typealias Configuration = (rootObject: PayloadConvertible, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)
    
    func convert(_ jsonValueConvertible: JSONValueConvertible, configuration: Configuration) -> Payload.JSON.Value?
    func convert(_ multipartValueConvertible: MultipartValueConvertible, configuration: Configuration) -> Payload.Multipart.Value?
    func multipartKey(from configuration: Configuration) -> String
}


// MARK: // Public
// MARK: -
public protocol PayloadConvertible: PayloadElementConvertible {
    func defaultPayloadDict() -> Payload.Dict
    func payloadDict(for method: ResourceHTTPMethod) -> Payload.Dict
    func toPayload(for method: ResourceHTTPMethod) -> Payload
}


// MARK: PayloadConvertible Default Implementation
public extension PayloadConvertible {
    public func payloadDict(for method: ResourceHTTPMethod) -> Payload.Dict {
        return self.defaultPayloadDict()
    }
    
    public func toPayload(for method: ResourceHTTPMethod) -> Payload {
        return Payload(self.payloadDict(for: method))
    }
}


// MARK: PayloadConvertible: PayloadElementConvertible
public extension PayloadConvertible {
    func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return self.defaultPayloadDict().toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: -
public protocol PayloadElementConvertible {
    func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element
}
