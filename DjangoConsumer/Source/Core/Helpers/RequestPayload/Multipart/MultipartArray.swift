//
//  MultipartArray.swift
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
public struct MultipartArray: CustomStringConvertible, ExpressibleByArrayLiteral, MultipartValueConvertible {
    public init(_ array: [MultipartValueConvertible]) {
        self.array = array
    }
    
    public init(arrayLiteral elements: MultipartValueConvertible...) {
        self.array = elements
    }
    
    let array: [MultipartValueConvertible]
    
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding) {
        self._merge(to: &payload, key: key, encoding: encoding)
    }
    
    public var description: String {
        return "MultipartArray([" + self.array.description + "])"
    }
}


// MARK: // Private
private extension MultipartArray {
    func _merge(to payload: inout MultipartPayload, key: String, encoding: MultipartEncoding) {
        self.array.enumerated().forEach({
            $0.element.merge(
                to: &payload,
                key: encoding.concatenate(outerKey: key, index: $0.offset),
                encoding: encoding
            )
        })
    }
}
