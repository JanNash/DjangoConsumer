//
//  Convertibles.swift
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
public protocol PayloadConvertible {
//    var payloadDict: Payload.Dict
    func toPayload() -> Payload
}


// MARK: -
public protocol PayloadElementConvertible {
    func splitToPayloadElement(path: String) -> Payload.Element
}


// MARK: -
public protocol JSONValueConvertible: PayloadElementConvertible {
    func toJSONValue() -> Payload.JSON.Value
}


// MARK: PayloadValueConvertible Default Implementation
extension JSONValueConvertible {
    public func splitToPayloadElement(path: String) -> Payload.Element {
        return (self.toJSONValue().unwrap(), [:])
    }
}


// MARK: -
public protocol MultipartValueConvertible: PayloadElementConvertible {
    func toMultipartValue() -> Payload.Multipart.Value
}


// MARK: PayloadValueConvertible Default Implementation
extension MultipartValueConvertible {
    public func splitToPayloadElement(path: String) -> Payload.Element {
        return (nil, [path: self.toMultipartValue()])
    }
}
