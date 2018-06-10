//
//  MultipartDict.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 09.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public struct MultipartDict: CustomStringConvertible, ExpressibleByDictionaryLiteral, MultipartPayloadConvertible, MultipartValueConvertible {
    public init(_ dict: [String: MultipartValueConvertible]) {
        self.dict = dict
    }
    
    public init(dictionaryLiteral elements: (String, MultipartValueConvertible)...) {
        self.dict = Dictionary(uniqueKeysWithValues: elements)
    }
    
    let dict: [String: MultipartValueConvertible]
    
    public func encode(key: String?, encoding: MultipartEncoding) -> MultipartPayload {
        return self._encode(key: key, encoding: encoding)
    }
    
    public var description: String {
        return "MultipartDict(" + self.dict.description + ")"
    }
    
    public func unwrap(using encoding: MultipartEncoding) -> RequestPayload.Unwrapped {
        return .multipart(self.encode(key: nil, encoding: encoding))
    }
}


// MARK: // Private
private extension MultipartDict {
    func _encode(key: String?, encoding: MultipartEncoding) -> MultipartPayload {
        var payload: MultipartPayload = [:]
        self.dict.forEach({
            $0.value.merge(
                to: &payload,
                key: encoding.concatenate(outerKey: key, innerKey: $0.key),
                encoding: encoding
            )
        })
        return payload
    }
}
