//
//  Payload.Dict (PayloadElementConvertible).swift
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
extension Payload.Dict/*: PayloadElementConvertible*/ {
    public func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
private extension Payload.Dict/*: PayloadElementConvertible*/ {
    func _toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        self.forEach({
            let (key, value): (String, Value) = $0
            Payload.Utils_.merge(
                value.toPayloadElement(
                    conversion: conversion,
                    configuration: (
                        rootObject: configuration.rootObject,
                        method: configuration.method,
                        multipartPath: configuration.multipartPath + .key(key),
                        currentKey: key
                    )
                ),
                to: &jsonPayload,
                and: &multipartPayload
            )
        })
        
        return (jsonPayload, multipartPayload)
    }
}
