//
//  Foo.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 19.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import SwiftyJSON
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockListGettable: ListGettableNoAuth, Equatable {
    // Init
    init(name: String) {
        self.name = name
    }
    
    // Keys
    struct Keys {
        static let name: String = "name"
    }
    
    // Variables
    private(set) var name: String = "0"
    
    // ListGettable
    init(json: JSON) {
        self.name = json[Keys.name].string!
    }
    
    static var listGETdefaultNode: Node = MockNode.main
    static var listGettableClients: [ListGettableClient] = []
}
