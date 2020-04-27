//
//  Optional (PayloadElementConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Optional: PayloadElementConvertible where Wrapped: PayloadElementConvertible {
    public func toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        return self._toPayloadElement(conversion: conversion, configuration: configuration)
    }
}


// MARK: // Private
private extension Optional where Wrapped: PayloadElementConvertible {
    func _toPayloadElement(conversion: PayloadConversion, configuration: (rootObject: PayloadConvertible?, method: ResourceHTTPMethod, multipartPath: Payload.Multipart.Path, currentKey: String)) -> Payload.Element {
        switch self {
        case .some(let convertible):
            return convertible.toPayloadElement(conversion: conversion, configuration: configuration)
        case .none:
            return (nil, [:])
        }
    }
}
