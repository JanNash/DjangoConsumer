//
//  Foo.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockListGettable: ListGettable, NeedsNoAuth {
    // Init
    init(id: String) {
        self.id = id
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
    }
    
    // Variables
    private(set) var id: String = "0"
    
    // ListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
    }
    
    static var defaultNode: Node = MockNode.main
    static var listGettableClients: [ListGettableClient] = []
}
