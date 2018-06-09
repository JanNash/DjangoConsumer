//
//  MultipartEncoding.swift
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
public protocol MultipartPayloadConvertible: MultipartValueConvertible {
    func encode(key: String?, encoding: MultipartEncoding) -> MultipartPayload
}


public protocol MultipartValueConvertible {
    func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding)
}


public extension MultipartValueConvertible {
    static func dict(_ dict: [String: MultipartValueConvertible]) -> MultipartDict {
        return MultipartDict(dict)
    }
}


// MARK: -
public protocol MultipartEncoding {
    typealias Convertible = MultipartValueConvertible
    typealias ContentType = Multipart.ContentType
    
    func concatenate(outerKey: String?, innerKey: String/*, for value: Convertible, with contentType: ContentType*/) -> String
    func concatenate(outerKey: String, index: Int/*, for value: Convertible, with contentType: ContentType*/) -> String
    func merge(_ convertible: Convertible, key: String, to payload: inout MultipartPayload)
    func mergeNull(with contentType: ContentType, to payload: inout MultipartPayload, key: String)
}


public extension MultipartEncoding {
    public func concatenate(outerKey: String?, innerKey: String/*, for value: Convertible, with contentType: ContentType*/) -> String {
        return outerKey?.appending(".").appending(innerKey) ?? innerKey
    }
    
    public func concatenate(outerKey: String, index: Int/*, for value: Convertible, with contentType: ContentType*/) -> String {
        return outerKey + "[\(index)]"
    }
    
    public func merge(_ convertible: Convertible, key: String, to payload: inout MultipartPayload) {
        convertible.merge(to: &payload, key: key, encoding: self)
    }
    
    func mergeNull(with contentType: ContentType, to payload: inout MultipartPayload, key: String) {
        payload[key] = contentType.null
    }
}
