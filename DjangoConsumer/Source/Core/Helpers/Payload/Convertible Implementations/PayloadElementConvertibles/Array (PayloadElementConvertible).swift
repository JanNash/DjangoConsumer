//
//  Array (PayloadElementConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - : PayloadElementConvertible
extension Array: PayloadElementConvertible where Element: PayloadElementConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: : PayloadElementConvertible Implementation
private extension Array/*: PayloadElementConvertible*/ where Element: PayloadElementConvertible {
    func _toPayloadElement(conversion: PayloadConversion, configuration: PayloadConversion.Configuration) -> Payload.Element {
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        self.enumerated().forEach({
            Payload.Utils_.merge(
                $0.element.toPayloadElement(
                    conversion: conversion,
                    configuration: (
                        rootObject: configuration.rootObject,
                        method: configuration.method,
                        multipartPath: configuration.multipartPath + .index($0.offset),
                        currentKey: configuration.currentKey
                    )
                ),
                to: &jsonPayload,
                and: &multipartPayload
            )
        })
        
        return (jsonPayload, multipartPayload)
    }
}
