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
public struct PayloadDict: ExpressibleByDictionaryLiteral {
    // Typealiases
    public typealias DictType = [String: PayloadElementConvertible]
    public typealias Index = PayloadDict.DictType.Index
    public typealias Key = PayloadDict.DictType.Key
    public typealias Value = PayloadDict.DictType.Value
    public typealias Element = (key: PayloadDict.Key, value: PayloadDict.Value)
    
    // ExpressibleByDictionaryLiteral Init
    public init(dictionaryLiteral elements: (PayloadDict.Key, PayloadDict.Value)...) {
        self.dict = Dictionary(elements, uniquingKeysWith: { _, r in r })
    }
    
    // Internal Variables
    var dict: PayloadDict.DictType
}


// MARK: Collection Conformance
extension PayloadDict: Collection {
    public var startIndex: PayloadDict.Index {
        return self.dict.startIndex
    }
    
    public var endIndex: PayloadDict.Index {
        return self.dict.endIndex
    }
    
    public func index(after i: PayloadDict.Index) -> PayloadDict.DictType.Index {
        return self.dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self.dict[key] }
        set { self.dict[key] = newValue }
    }
    
    public subscript(position: PayloadDict.DictType.Index) -> (key: PayloadDict.Key, value: PayloadDict.Value) {
        return self.dict[position]
    }
}
