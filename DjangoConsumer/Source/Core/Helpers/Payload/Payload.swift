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
public struct Payload {
    // Variables
    public private(set) var json: [String: Any]
    public private(set) var multipart: [String: Multipart.Value]
    
    // Element
    public typealias Element = (json: Any?, multipart: [String: Multipart.Value])
    
    // Dict
    public struct Dict: Collection, ExpressibleByDictionaryLiteral {
        // Typealiases
        public typealias DictType = [String: PayloadElementConvertible]
        
        // ExpressibleByDictionaryLiteral Init
        public init(dictionaryLiteral elements: (Key, Value)...) {
            self.dict = Dictionary(elements, uniquingKeysWith: { _, r in r })
        }
        
        // Internal Variables
        var dict: Payload.Dict.DictType
    }
    
    // JSON
    public struct JSON {
        // Typed Value
        public enum Value: Equatable {
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
        }
        
        // Init
        init(_ value: Value) {
            self.value = value
        }
        
        // Inner Value
        let value: Value
    }
    
    public enum Multipart {
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
