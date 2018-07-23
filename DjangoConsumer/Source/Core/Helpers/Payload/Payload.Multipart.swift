//
//  Payload.Multipart.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 23.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: -
public extension Payload.Multipart {
    public static func value(_ data: Data?, _ contentType: ContentType) -> Value {
        return self._value(data, contentType)
    }
}


// MARK: // Private
private extension Payload.Multipart {
    static func _value(_ data: Data?, _ contentType: ContentType) -> Value {
        if let data: Data = data {
            return (data, contentType)
        } else {
            return contentType.null
        }
    }
}
