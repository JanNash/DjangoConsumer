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
    func mapToDict<K, V>(strategy: Dictionary<K, V>.MergeStrategy) -> [K: V] where Element == (K, V) {
        return Dictionary(self, strategy: strategy)
    }
    
    func mapToDict<K, V>(_ transform: (Element) throws -> (key: K, value: V), strategy: Dictionary<K, V>.MergeStrategy) rethrows -> [K: V] {
        return Dictionary(try self.map(transform), strategy: strategy)
    }
    
    func mapToDict<K, V, N>(_ transformValue: (V) throws -> N, strategy: Dictionary<K, N>.MergeStrategy) rethrows -> [K: N] where Element == (K, V), K: Hashable {
        return Dictionary(try self.map({ ($0.0, try transformValue($0.1)) }), strategy: strategy)
    }
}
