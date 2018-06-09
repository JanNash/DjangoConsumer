//
//  MultipartConvertibles.swift
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
// MARK: -
public protocol MultipartPayloadConvertible: MultipartValueConvertible {
    func encode(key: String?, encoding: MultipartEncoding) -> MultipartPayload
}


// MARK: -
public protocol MultipartValueConvertible {
    func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding)
}


// MARK: ExpressibleByDictionaryLiteral where Self: MultipartPayloadConvertible
public extension ExpressibleByDictionaryLiteral where Self: MultipartPayloadConvertible {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding) {
        payload.merge(self.encode(key: key, encoding: encoding), uniquingKeysWith: { _, r in r })
    }
}


// MARK: Dictionary<String, MultipartValueConvertible>: MultipartValueConvertible
extension Dictionary: MultipartValueConvertible where Key == String, Value: MultipartValueConvertible {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding) {
        self.forEach({
            $0.value.merge(
                to: &payload,
                key: encoding.concatenate(outerKey: key, innerKey: $0.key),
                encoding: encoding
            )
        })
    }
}


// MARK: Array<MultipartValueConvertible>: MultipartValueConvertible
extension Array: MultipartValueConvertible where Element: MultipartValueConvertible {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding) {
        self.enumerated().forEach({
            $0.element.merge(
                to: &payload,
                key: encoding.concatenate(outerKey: key, index: $0.offset),
                encoding: encoding
            )
        })
    }
}
