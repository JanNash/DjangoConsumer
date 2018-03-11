//
//  ifThisIsAThen.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public func ifT<O, T, R>(his object: O, isA: T.Type, then closure: ((T) -> R)?) -> R? {
    guard let o: T = object as? T else { return nil }
    return closure?(o)
}

public func ifT<O, T>(his object: O, isA: T.Type, then closure: ((T) -> Void)?) {
    if let o: T = object as? T { closure?(o) }
}
