//
//  LocalTestNode.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 21.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
class LocalTestNode {
    // DRFNode Conformance
    var baseURL: URL = URL(string: "http://localhost:8080")!
}


extension LocalTestNode: DRFNode {
    func relativeListURL<T>(for resourceType: T.Type) -> URL where T : DRFListGettable {
        if resourceType == Foo.self {
            return URL(string: "foos")!
        }
        fatalError("No relative list URL definde for resourceType: \(resourceType)")
    }
}
