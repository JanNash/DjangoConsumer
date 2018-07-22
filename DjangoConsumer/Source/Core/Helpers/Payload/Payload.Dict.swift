//
//  Payload.Dict.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 17.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public extension Payload.Dict {
    public func toPayload(conversion: PayloadConversion, rootObject: PayloadConvertible?, method: ResourceHTTPMethod) -> Payload {
        return self._toPayload(conversion: conversion, rootObject: rootObject, method: method)
    }
}


// MARK: // Private
private extension Payload.Dict {
    func _toPayload(conversion: PayloadConversion, rootObject: PayloadConvertible?, method: ResourceHTTPMethod) -> Payload {
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        self.forEach({
            let (key, value): (String, Value) = $0
            let payloadElement: Payload.Element = value.toPayloadElement(
                conversion: conversion,
                configuration: (
                    rootObject: rootObject,
                    method: method,
                    multipartPath: Payload.Multipart.Path(key),
                    currentKey: key
                )
            )
            
            if let json: Payload.JSON.UnwrappedPayload = payloadElement.json {
                jsonPayload.merge(json, strategy: .overwriteOldValue)
            }
            
            if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
                multipartPayload.merge(multipart, strategy: .overwriteOldValue)
            }
        })
        
        return Payload(_rootObject: rootObject, _method: method, _json: jsonPayload, _multipart: multipartPayload)
    }
}
