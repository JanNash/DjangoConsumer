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
    
    // JSON
    public struct JSON {
        public struct Value: Equatable {
            indirect enum Type_: Equatable {
                case null
                case bool(Bool?)
                case int(Int?)
                case uInt(UInt?)
                case float(Double?)
                case string(String?)
            }
            
            // Init
            init(_ typedValue: Type_) {
                self.typedValue = typedValue
            }
            
            // Value
            let typedValue: Type_
        }
    }
    
    public enum Multipart {
        public typealias Value = (Data, ContentType)
        
        public enum ContentType: String, CustomStringConvertible {
            case imageJPEG = "image/jpeg"
            case imagePNG = "image/png"
            // TODO: Add missing content types
            
            var null: Value {
                return ("null".data(using: .utf8)!, self)
            }
            
            public var description: String {
                return self.rawValue
            }
        }
    }
}
