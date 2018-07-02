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
public protocol PayloadConvertible {
    func payloadDict() -> Payload.Dict
    func toPayload() -> Payload
}


// MARK: PayloadConvertible Default Implementation
public extension PayloadConvertible {
    public func toPayload() -> Payload {
        return Payload(self.payloadDict())
    }
}


// MARK: -
public protocol PayloadElementConvertible {
    func toPayloadElement(path: String, pathHead: String) -> Payload.Element
}
