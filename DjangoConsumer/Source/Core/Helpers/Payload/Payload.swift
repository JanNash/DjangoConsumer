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
    public private(set) var json: JSON.Payload
    public private(set) var multipart: Multipart.Payload
    
    // Element
    public typealias Element = (json: JSON.RawPayloadValue?, multipart: Multipart.RawPayloadValue?)
    
    // Dict
    public struct Dict: Collection, ExpressibleByDictionaryLiteral, PayloadConvertible {
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
    public enum JSON {
        // RawPayloadValue
        public typealias RawPayloadValue = Any
        
        // Payload
        public typealias Payload = [String: RawPayloadValue]
        
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
        }
    }
    
    public enum Multipart {
        // RawPayloadValue
        public typealias RawPayloadValue = [(String, Multipart.Value)]
        
        // Payload
        public typealias Payload = [(String, Multipart.Value)]
        
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
