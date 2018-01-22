//
//  TestFilterKeys.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 22.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Enum Declaration
enum TestFilterKeys: String {
    case bar = "bar"
}


// MARK: Protocol Conformances
extension TestFilterKeys: DRFFilterKey {
    var string: String {
        return self.rawValue
    }
}
