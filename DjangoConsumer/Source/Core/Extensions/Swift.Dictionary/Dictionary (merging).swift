//
//  Dictionary (merging).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: -
public extension Dictionary {
    public enum MergeStrategy {
        case keepOldValue
        case overwriteOldValue
        
        var closure: (Value, Value) -> Value {
            switch self {
            case .keepOldValue:         return { old, _ in old }
            case .overwriteOldValue:    return { _, new in new }
            }
        }
    }
    
    public init<S>(_ keysAndValues: S, strategy: MergeStrategy) where S : Sequence, S.Element == (Key, Value) {
        try! self.init(keysAndValues, uniquingKeysWith: strategy.closure)
    }
    
    public mutating func merge(_ dictionary: [Key: Value], strategy: MergeStrategy) {
        self.merge(dictionary, uniquingKeysWith: strategy.closure)
    }
    
    public func merging(_ dictionary: [Key: Value], strategy: MergeStrategy) -> [Key: Value] {
        return self.merging(dictionary, uniquingKeysWith: strategy.closure)
    }
}
