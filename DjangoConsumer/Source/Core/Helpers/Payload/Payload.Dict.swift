//
//  Payload.Dict.swift
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
// MARK: -
public extension Payload.Dict {
    // Collection Typealiases
    public typealias Index = Payload.Dict.DictType.Index
    public typealias Key = Payload.Dict.DictType.Key
    public typealias Value = Payload.Dict.DictType.Value
    public typealias Element = (key: Key, value: Value)
}


// MARK: Collection Conformance
extension Payload.Dict {
    public var startIndex: Index {
        return self.dict.startIndex
    }
    
    public var endIndex: Index {
        return self.dict.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return self.dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self.dict[key] }
        set { self.dict[key] = newValue }
    }
    
    public subscript(position: Index) -> (key: Key, value: Value) {
        return self.dict[position]
    }
}


// MARK: PayloadConvertible
extension Payload.Dict/*: PayloadConvertible*/ {
    public func payloadDict() -> Payload.Dict {
        return self
    }
    
    public func toPayload() -> Payload  {
        return self._toPayload()
    }
}


// MARK: // Private
// MARK: PayloadConvertible Implementation
private extension Payload.Dict/*: PayloadConvertible*/ {
    func _toPayload() -> Payload {
        var multipartPayload: Payload.Multipart.Payload = []
        let jsonPayload: Payload.JSON.Payload = Dictionary<String, Any>(
            self.compactMap({
                let (key, convertible): (String, PayloadElementConvertible) = $0
                let payloadElement: Payload.Element = convertible.toPayloadElement(path: key)
                
                if let multipart: Payload.Multipart.Payload = payloadElement.multipart {
                    multipartPayload = multipart
                }
                
                if let json: Any = payloadElement.json {
                    return (key, json)
                }
                
                return nil
            }),
            uniquingKeysWith: { _, r in r }
        )
        
        return Payload(json: jsonPayload, multipart: multipartPayload)
    }
}
