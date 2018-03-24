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

import Foundation


// MARK: // Public
public extension URL {
    public static func +(_ lhs: URL, rhs: URL) -> URL {
        return lhs.appendingPathComponent(rhs.absoluteString)
    }
    
    public static func +(_ lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
    
    public static func +<T>(_ lhs: URL, rhs: ResourceID<T>) -> URL {
        return lhs.appendingPathComponent(rhs.string)
    }
}