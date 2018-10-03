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
        let currentKey: String = configuration.currentKey
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        if let multipartConvertibleArray: [MultipartValueConvertible] = self as? [MultipartValueConvertible] {
            multipartConvertibleArray.enumerated().forEach({
                let payloadElement: Payload.Element = DefaultImplementations.MultipartValueConvertible.payloadElement(
                    from: $0.element,
                    conversion: (
                        conversion,
                        (
                            rootObject: configuration.rootObject,
                            method: configuration.method,
                            multipartPath: configuration.multipartPath + .index($0.offset),
                            currentKey: currentKey
                        )
                    )
                )
                
                if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
                    multipartPayload.merge(multipart, strategy: .overwriteOldValue)
                }
            })
            
            return (nil, multipartPayload)
        }
        
        var jsonArray: [Any] = []
        
        self.enumerated().forEach({
            let payloadElement: Payload.Element = $0.element.toPayloadElement(
                conversion: conversion,
                configuration: (
                    rootObject: configuration.rootObject,
                    method: configuration.method,
                    multipartPath: configuration.multipartPath + .index($0.offset),
                    currentKey: currentKey
                )
            )
            
            if let jsonElement: Any = payloadElement.json?[currentKey] {
                jsonArray.append(jsonElement)
            }
            
            if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
                multipartPayload.merge(multipart, strategy: .overwriteOldValue)
            }
        })
        
        if !self.isEmpty && jsonArray.isEmpty {
            return (nil, multipartPayload)
        }
        
        return ([currentKey: jsonArray], multipartPayload)
    }
}
