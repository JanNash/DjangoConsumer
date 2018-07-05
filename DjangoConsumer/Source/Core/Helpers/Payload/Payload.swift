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
    mutating func merge(_ json: JSON.Dict) {
        self.merge(json._dict)
    }
    
    mutating func merge(_ multipart: Multipart.Dict) {
        self.merge(multipart._dict)
    }
    
    mutating func merge<C>(_ dict: C) where C: Collection, C.Element == Dict.Element {
        self._merge(dict)
    }
    
    func merging(_ json: JSON.Dict) -> Payload {
        return self.merging(json._dict)
    }
    
    func merging(_ multipart: Multipart.Dict) -> Payload {
        return self.merging(multipart._dict)
    }
    
    func merging<C>(_ dict: C) -> Payload where C: Collection, C.Element == Dict.Element {
        return self._merging(dict)
    }
}


// MARK: -
public struct Payload: ExpressibleByDictionaryLiteral, Equatable {
    // Fileprivate Inits
    fileprivate init() {}
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
        // FIXME: A mergeStrategy should be passed into mapToDict
        self = ._from(elements.mapToDict())
    }
    
    // Variables
    public private(set) var json: JSON.UnwrappedPayload = [:]
    public private(set) var multipart: Multipart.UnwrappedPayload = [:]
    
    // Equatable Conformance
    public static func == (lhs: Payload, rhs: Payload) -> Bool {
        return lhs.__eq__(rhs)
    }
    
    // Element
    public typealias Element = (json: JSON.UnwrappedPayload?, multipart: Multipart.UnwrappedPayload?)
    
    // Dict
    public struct Dict: Collection, ExpressibleByDictionaryLiteral, PayloadElementConvertible {
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
        
        // PayloadElementConvertible Conformance
        public func toPayloadElement(path: String, pathHead: String) -> Payload.Element {
            return self._toPayloadElement(path: path, pathHead: pathHead)
        }
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
        public struct Dict: Collection, Equatable, ExpressibleByDictionaryLiteral, JSONValueConvertible {
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
            
            // Fileprivate Variables
            fileprivate var _dict: DictType
            
            // Equatable Conformance
            public static func == (lhs: Payload.JSON.Dict, rhs: Payload.JSON.Dict) -> Bool {
                return lhs.toJSONValue() == rhs.toJSONValue()
            }
            
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
    static func _from<C>(_ dict: C) -> Payload where C: Collection, C.Element == (key: String, value: Payload.Value) {
        var payload: Payload = Payload()

        dict.forEach({
            let (key, convertible): (String, PayloadElementConvertible) = $0
            _Utils._merge(
                convertible.toPayloadElement(path: key, pathHead: key),
                to: &payload.json,
                and: &payload.multipart
            )
        })
        
        return payload
    }
}


// MARK: Interface Implementation
private extension Payload {
    mutating func _merge<C>(_ dict: C) where C: Collection, C.Element == Dict.Element {
        let payload: Payload = ._from(dict)
        self.json.merge(payload.json, strategy: .overwriteOldValue)
        self.multipart.merge(payload.multipart, strategy: .overwriteOldValue)
    }
    
    func _merging<C>(_ dict: C) -> Payload where C: Collection, C.Element == Dict.Element {
        var payload: Payload = self
        payload.merge(dict)
        return payload
    }
}


// MARK: Equatable Implementation
private extension Payload {
    func __eq__(_ other: Payload) -> Bool {
        let jsonValueDictOf: (Payload) -> [String: JSON.Value] = {
            $0.json.mapValues({ ($0 as! JSONValueConvertible).toJSONValue() })
        }
        
        if jsonValueDictOf(self) != jsonValueDictOf(other) {
            return false
        }
        
        for (key, lValue) in self.multipart {
            guard
                let rValue: Multipart.Value = other.multipart[key],
                lValue.1 == rValue.1, lValue.0 == rValue.0
                else { return false }
        }
        
        return true
    }
}


// MARK: -
// MARK: Payload.Dict: PayloadElementConvertible
private extension Payload.Dict/*: PayloadElementConvertible*/ {
    func _toPayloadElement(path: String, pathHead: String) -> Payload.Element {
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        self.forEach({
            let (key, value): (String, Value) = $0
            // FIXME: The path creation should be extracted
            _Utils._merge(
                value.toPayloadElement(path: path + "." + key, pathHead: key),
                to: &jsonPayload,
                and: &multipartPayload
            )
        })
        
        return (jsonPayload, multipartPayload)
    }
}


// MARK: Utilities
private enum _Utils {
    static func _merge(_ payloadElement: Payload.Element, to jsonPayload: inout Payload.JSON.UnwrappedPayload, and multipartPayload: inout Payload.Multipart.UnwrappedPayload) {
        if let json: Payload.JSON.UnwrappedPayload = payloadElement.json {
            jsonPayload.merge(json, strategy: .overwriteOldValue)
        }
        
        if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
            multipartPayload.merge(multipart, strategy: .overwriteOldValue)
        }
    }
}
