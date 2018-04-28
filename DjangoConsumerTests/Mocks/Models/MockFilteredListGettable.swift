//
//  MockFilteredListGettable.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 24.01.18.
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
struct MockFilteredListGettable: FilteredListGettableNoAuth {
    // Init
    init(id: String, date: Date, name: String) {
        self.id = id
        self.name = name
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
        static let name: String = "name"
    }
    
    // Variables
    private(set) var id: String = "0"
    private(set) var name: String = "A"
    
    // ListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
        self.name = json[Keys.name].string!
    }
    
    static var listGETdefaultNode: NoAuthNode = MockNode.main
    static var listGettableClients: [ListGettableClient] = []
}
