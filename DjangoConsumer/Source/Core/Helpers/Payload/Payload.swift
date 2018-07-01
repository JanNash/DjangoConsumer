//
//  Payload.swift
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
// MARK: Interface
public extension Payload {
    public mutating func append(_ dict: JSON.Dict) {
        self.json.append(contentsOf: dict.map({ ($0, $1.toJSONValue()) }))
    }
    
    public mutating func append(_ multipart: Multipart.Payload) {
        self.multipart.append(contentsOf: multipart)
    }
}


// MARK: -
public struct Payload {
    // Variables
    public private(set) var json: JSON.Payload
    public private(set) var multipart: Multipart.Payload
    
    // Element
    public typealias Element = (json: JSON.Payload?, multipart: Multipart.Payload?)
    
    // JSON
    public enum JSON {
        // Payload
        public typealias Payload = [String: JSONValueConvertible]
        
        // Typed Value
        public enum Value: Equatable, CustomStringConvertible {
            case bool(Bool?)
            case int(Int?)
            case int8(Int8?)
            case int16(Int16?)
            case int32(Int32?)
            case int64(Int64?)
            case uInt(UInt?)
            case uInt8(UInt8?)
            case uInt16(UInt16?)
            case uInt32(UInt32?)
            case uInt64(UInt64?)
            case float(Float?)
            case double(Double?)
            case string(String?)
            // Collections
            case array([Value])
            case dict([String: Value])
            // Null
            // TODO: Document when and how null is used
            case null
        }
    
        // Dict
        public struct Dict: Collection, ExpressibleByDictionaryLiteral, JSONValueConvertible {
            // Typealiases
            public typealias DictType = JSON.Payload
            
            // Collection Typealiases
            public typealias Index = DictType.Index
            public typealias Key = DictType.Key
            public typealias Value = DictType.Value
            public typealias Element = (key: Key, value: Value)
            
            // Init
            public init(_ dictionary: [Key: Value]) {
                self._dict = dictionary
            }
            
            // ExpressibleByDictionaryLiteral Init
            public init(dictionaryLiteral elements: (Key, Value)...) {
                self._dict = Dictionary(elements, strategy: .overwriteOldValue)
            }
            
            // Private Variables
            private var _dict: DictType
            
            // JSONValueConvertible Conformance
            public func toJSONValue() -> JSON.Value {
                return .dict(self._dict.mapToDict({ ($0, $1.toJSONValue()) }))
            }
            
            // Unwrap
            func unwrap() -> [String: Any] {
                return self._dict.mapValues({ $0.toJSONValue().unwrap() })
            }
        }
    }
    
    public enum Multipart {
        // Payload
        public typealias Payload = [String: MultipartValueConvertible]
        
        // Value
        public typealias Value = (Data, ContentType)
        
        // ContentType
        public enum ContentType: String, CustomStringConvertible {
            case imageJPEG = "image/jpeg"
            case imagePNG = "image/png"
            // TODO: Add missing content types
            
            // null
            var null: Value {
                return ("null".data(using: .utf8)!, self)
            }
            
            // CustomStringConvertible
            public var description: String {
                return self.rawValue
            }
        }
    }
}


// MARK: Payload.JSON.Dict: Collection
extension Payload.JSON.Dict/*: Collection*/ {
    public var startIndex: Index {
        return self._dict.startIndex
    }
    
    public var endIndex: Index {
        return self._dict.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return self._dict.index(after: i)
    }
    
    public subscript(key: Key) -> Value? {
        get { return self._dict[key] }
        set { self._dict[key] = newValue }
    }
    
    public subscript(position: Index) -> (key: Key, value: Value) {
        return self._dict[position]
    }
}
