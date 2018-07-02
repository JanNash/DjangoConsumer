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
// MARK: -
public struct Payload: ExpressibleByDictionaryLiteral {
    // Fileprivate Init
    fileprivate init(_json: JSON.UnwrappedPayload, _multipart: Multipart.UnwrappedPayload) {
        self.json = _json
        self.multipart = _multipart
    }
    
    // Public Init
    public init(_ payloadDict: Payload.Dict) {
        self = ._from(payloadDict._dict)
    }
    
    // ExpressibleByDictionaryLiteral Init
    public init(dictionaryLiteral elements: (Payload.Dict.Key, Payload.Dict.Value)...) {
        // FIXME: A mergeStrategy should be passed in here
        self = ._from(elements.mapToDict())
    }
    
    // Variables
    public private(set) var json: JSON.UnwrappedPayload = [:]
    public private(set) var multipart: Multipart.UnwrappedPayload = [:]
    
    // Element
    public typealias Element = (json: JSON.UnwrappedPayload?, multipart: Multipart.UnwrappedPayload?)
    
    // Dict
    public struct Dict: Collection, ExpressibleByDictionaryLiteral {
        // Typealiases
        public typealias DictType = [String: PayloadElementConvertible]
        public typealias MergeStrategy = DictType.MergeStrategy
        
        // Collection Typealiases
        public typealias Index = DictType.Index
        public typealias Key = DictType.Key
        public typealias Value = DictType.Value
        public typealias Element = (key: Key, value: Value)
        
        // ExpressibleByDictionaryLiteral Init
        public init(dictionaryLiteral elements: (Key, Value)...) {
            self._dict = Dictionary(elements, strategy: .overwriteOldValue)
        }
        
        // Private Variables
        fileprivate var _dict: DictType
    }
    
    // JSON
    public enum JSON {
        // UnwrappedPayload
        public typealias UnwrappedPayload = [String: Any]
        
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
            public typealias DictType = [String: JSONValueConvertible]
            public typealias MergeStrategy = DictType.MergeStrategy
            
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
            fileprivate var _dict: DictType
            
            // JSONValueConvertible Conformance
            public func toJSONValue() -> JSON.Value {
                return .dict(self._dict.mapToDict({ ($0, $1.toJSONValue()) }))
            }
        }
    }
    
    public enum Multipart {
        // UnwrappedPayload
        public typealias UnwrappedPayload = [String: Value]
        
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
        
        public struct Dict: Collection, ExpressibleByDictionaryLiteral {
            // Typealiases
            public typealias DictType = [String: MultipartValueConvertible]
            public typealias MergeStrategy = DictType.MergeStrategy
            
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
            fileprivate var _dict: DictType
        }
    }
}


// MARK: Payload.Dict: Collection
extension Payload.Dict/*: Collection*/ {
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


// MARK: Payload.Multipart.Dict: Collection
extension Payload.Multipart.Dict/*: Collection*/ {
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


// MARK: // Private
// MARK: Common Initializer
private extension Payload {
    static func _from(_ payloadDict: Payload.Dict.DictType) -> Payload {
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        payloadDict.forEach({
            let (key, convertible): (String, PayloadElementConvertible) = $0
            let payloadElement: Payload.Element = convertible.toPayloadElement(path: key, pathHead: key)
            
            if let json: Payload.JSON.UnwrappedPayload = payloadElement.json {
                jsonPayload.merge(json, strategy: .overwriteOldValue)
            }
            
            if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
                multipartPayload.merge(multipart, strategy: .overwriteOldValue)
            }
        })
        
        return Payload(_json: jsonPayload, _multipart: multipartPayload)
    }
}
