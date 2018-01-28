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
final class TestNode: DRFNode {
    // Singleton
    static let main: TestNode = TestNode()
    
    // DRFNode Conformance
    // Basic Setup
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Pagination
    func defaultLimit<T>(for resourceType: T.Type) -> UInt where T : DRFListGettable {
        return 1000
    }
    
    // List GET endpoints
    func relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        return self._relativeListURL(for: resourceType)
    }
}


// MARK: // Private
// MARK: DRFNode Implementations
private extension TestNode {
    func _relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == MockListGettable.self {
            return URL(string: "listgettables/")!
        } else if resourceType == MockFilteredListGettable.self {
            return URL(string: "filteredlistgettables/")!
        }
        // FIXME: Throw a real Error here?
        fatalError("[TestNode] No URL registered for '\(resourceType)'")
    }
}
