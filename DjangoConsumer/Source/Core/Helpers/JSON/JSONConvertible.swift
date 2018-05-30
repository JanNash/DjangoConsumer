//
//  JSONConvertible.swift
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
// MARK: Protocol Declaration
public protocol JSONConvertible: CustomStringConvertible {
    func jsonDict() -> JSONDict
}


// MARK: Default Implementations
// MARK: CustomStringConvertible
extension JSONConvertible/*: CustomStringConvertible*/ {
    public var description: String {
        return "\(type(of: self))(\(JSONValue.dict(self.jsonDict()).description)"
    }
}
