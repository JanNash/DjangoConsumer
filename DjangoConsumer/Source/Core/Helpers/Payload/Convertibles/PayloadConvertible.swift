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


// MARK: // Public
// MARK: -
public protocol PayloadElementConvertible {
    func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element
}


// MARK: -
public protocol PayloadConvertible: PayloadElementConvertible {
    func defaultPayloadDict() -> Payload.Dict
    func payloadDict(rootObject: PayloadConvertible?, method: ResourceHTTPMethod) -> Payload.Dict
    func toPayload(conversion: PayloadConversion, method: ResourceHTTPMethod) -> Payload
}


// MARK: PayloadConvertible Default Implementation
public extension PayloadConvertible {
    func payloadDict(rootObject: PayloadConvertible?, method: ResourceHTTPMethod) -> Payload.Dict {
        return self.defaultPayloadDict()
    }
    
    func toPayload(conversion: PayloadConversion, method: ResourceHTTPMethod) -> Payload {
        return self.payloadDict(rootObject: self, method: method).toPayload(conversion: conversion, rootObject: self, method: method)
    }
}


// MARK: PayloadConvertible: PayloadElementConvertible
public extension PayloadConvertible {
    func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return self.defaultPayloadDict().toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: -
public protocol PayloadConversion {
    typealias Configuration = (
        rootObject: PayloadConvertible?,
        method: ResourceHTTPMethod,
        multipartPath: Payload.Multipart.Path,
        currentKey: String
    )
    
    func convert(_ jsonValueConvertible: JSONValueConvertible, configuration: Configuration) -> Payload.JSON.Value?
    func convert(_ multipartValueConvertible: MultipartValueConvertible, configuration: Configuration) -> Payload.Multipart.Value?
    func multipartKey(from configuration: Configuration) -> String
}


// MARK: PayloadConversion Default Implementations
public extension PayloadConversion {
    func convert(_ jsonValueConvertible: JSONValueConvertible, configuration: Configuration) -> Payload.JSON.Value? {
        return nil
    }
    
    func convert(_ multipartValueConvertible: MultipartValueConvertible, configuration: Configuration) -> Payload.Multipart.Value? {
        return nil
    }
    
    func multipartKey(from configuration: Configuration) -> String {
        return DefaultImplementations.PayloadConversion.multipartKey(for: self, from: configuration)
    }
}


// MARK: -
public struct DefaultPayloadConversion: PayloadConversion {
    public init() {}
}


// MARK: -
// MARK: DefaultImplementations.PayloadConversion
extension DefaultImplementations.PayloadConversion {
    public static func multipartKey(for conversion: PayloadConversion, from configuration: PayloadConversion.Configuration) -> String {
        return self._multipartKey(for: conversion, from: configuration)
    }
}


// MARK: // Private
// MARK: DefaultPayloadConversion Implementation
private extension DefaultImplementations.PayloadConversion {
    static func _multipartKey(for conversion: PayloadConversion, from configuration: PayloadConversion.Configuration) -> String {
        var previousKeyHeadWasAnIndex: Bool = false
        let path: Payload.Multipart.Path = configuration.multipartPath
        return path.tail.reduce(path.head, { result, element in
            switch element {
            case .key(let key):
                defer { previousKeyHeadWasAnIndex = false }
                if previousKeyHeadWasAnIndex {
                    return result + key
                } else {
                    return result + "." + key
                }
            case .index(let index):
                previousKeyHeadWasAnIndex = true
                return result + "[" + "\(index)" + "]"
            }
        })
    }
}
