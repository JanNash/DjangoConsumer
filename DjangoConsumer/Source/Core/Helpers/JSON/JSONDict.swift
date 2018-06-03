//
//  JSONDict.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.05.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: Struct Declaration
public struct JSONDict: Equatable {
    // Public Init
    public init(_ dict: [String: JSONValueConvertible]) {
        self.dict = dict.mapValues({ $0.toJSONValue() })
    }
    
    // Value
    var dict: [String: JSONValue]
}


// MARK: Protocol Conformances
// MARK: ExpressibleByDictionaryLiteral
extension JSONDict: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONValueConvertible)...) {
        self.dict = elements.mapToDict({ $0.toJSONValue() })
    }
}


// MARK: CustomStringConvertible
extension JSONDict: CustomStringConvertible {
    public var description: String {
        return "JSONDict(\(self.dict.description))"
    }
}


// MARK: JSONValueConvertible
extension JSONDict: JSONValueConvertible {
    public func toJSONValue() -> JSONValue { return .dict(self) }
}


// MARK: // Internal
// MARK: Interface
extension JSONDict {
    func unwrap() -> [String: Any?] {
        return self.dict.mapValues(JSONValue.unwrap)
    }
}
