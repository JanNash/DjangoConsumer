//
//  TestFilterComparators.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 22.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Enum Declaration
enum TestFilterComparators: String {
    case lessThan = "__lt"
    case lessThanEqual = "__lte"
    case greaterThan = "__gt"
    case greaterThanEqual = "__gte"
    case iContains = "__icontains"
    // etc...
}


// MARK: Protocol Conformances
extension TestFilterComparators: DRFFilterComparator {
    var string: String {
        return self.rawValue
    }
}
