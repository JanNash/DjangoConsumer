//
//  Sequence (mapToDict).swift
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
public extension Sequence {
    public func mapToDict<K, V>(_ transform: (Element) throws -> (key: K, value: V)) rethrows -> [K: V] {
        return Dictionary(uniqueKeysWithValues: try self.map(transform))
    }
    
    public func mapToDict<K, V, N>(_ transformValue: (V) throws -> N) rethrows -> [K: N] where Element == (K, V), K: Hashable {
        return Dictionary(uniqueKeysWithValues: try self.map({ ($0.0, try transformValue($0.1)) }))
    }
}
