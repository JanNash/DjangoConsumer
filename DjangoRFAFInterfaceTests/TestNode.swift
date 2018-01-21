//
//  TestNode.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 21.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Class Declaration
class TestNode: DRFNode {
    // DRFNode Conformance
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    func relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        return self._relativeListURL(for: resourceType)
    }
}


// MARK: // Private
// MARK: DRFNode Implementations
private extension TestNode {
    func _relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == Foo.self {
            return URL(string: "foos")!
        }
        return URL(string: "")!
    }
}
