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
    public func toPayloadElement(path: String, pathHead: String) -> Payload.Element {
        return self.defaultPayloadDict().toPayloadElement(path: path, pathHead: pathHead)
    }
}


// MARK: -
public protocol PayloadElementConvertible {
    func toPayloadElement(path: String, pathHead: String) -> Payload.Element
}
