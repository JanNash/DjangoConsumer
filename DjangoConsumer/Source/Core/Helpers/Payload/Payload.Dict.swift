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
