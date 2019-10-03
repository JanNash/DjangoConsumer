//
//  URL+.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
public extension URL {
    static func +(_ lhs: URL, rhs: URL) -> URL {
        return lhs.appendingPathComponent(rhs.absoluteString)
    }
    
    static func +(_ lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
    
    static func +<T>(_ lhs: URL, rhs: ResourceID<T>) -> URL {
        return lhs.appendingPathComponent(rhs.string)
    }
}
