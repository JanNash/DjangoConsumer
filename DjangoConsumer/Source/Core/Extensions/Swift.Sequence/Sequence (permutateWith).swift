//
//  Sequence (permutateWith).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
public extension Sequence {
    public func permutate<S: Sequence>(with sequence: S) -> [(Self.Element, S.Element)] {
        return self.map({ element in sequence.map({ (element, $0) }) }).lazy.reduce([], +)
    }
}
