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
    func payloadDict() -> [String: PayloadElementConvertible]
    func toPayload() -> Payload
}


// MARK: PayloadConvertible Default Implementation
public extension PayloadConvertible {
    public func toPayload() -> Payload {
        return self._toPayload()
    }
}


// MARK: -
public protocol PayloadElementConvertible {
    func toPayloadElement(path: String, pathHead: String) -> Payload.Element
}


// MARK: // Private
// MARK: PayloadConvertible Default Implementation
private extension PayloadConvertible {
    func _toPayload() -> Payload {
        var multipartPayload: Payload.Multipart.Payload = [:]
        var jsonPayload: Payload.JSON.Payload = [:]
        
        self.payloadDict().forEach({
            let (key, convertible): (String, PayloadElementConvertible) = $0
            let payloadElement: Payload.Element = convertible.toPayloadElement(path: key, pathHead: key)
            
            if let multipart: Payload.Multipart.Payload = payloadElement.multipart {
                multipartPayload.merge(multipart, strategy: .overwriteOldValue)
            }
            
            if let json: Payload.JSON.Payload = payloadElement.json {
                jsonPayload.merge(json, strategy: .overwriteOldValue)
            }
        })
        
        return Payload(json: jsonPayload, multipart: multipartPayload)
    }
}
