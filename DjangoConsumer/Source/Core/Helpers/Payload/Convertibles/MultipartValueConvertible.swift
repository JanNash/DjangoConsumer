//
//  MultipartValueConvertible.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: Public
// MARK: -
public protocol MultipartValueConvertible: PayloadElementConvertible {
    func toMultipartValue() -> Payload.Multipart.Value
}


// MARK: PayloadValueConvertible Default Implementation
public extension MultipartValueConvertible {
    public func toPayloadElement(path: String, pathHead: String) -> Payload.Element {
        return (nil, [path: self])
    }
}
