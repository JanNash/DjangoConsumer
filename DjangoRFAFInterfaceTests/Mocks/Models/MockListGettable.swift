//
//  Foo.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Struct Declaration
struct TestListGettable: DRFListGettable {
    // Init
    init(id: String) {
        self.id = id
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
    }
    
    // Variables
    var id: String = "1"
    
    // DRFListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
    }
    
    static var defaultNode: DRFNode = TestNode.main
    static var clients: [DRFListGettableClient] = []
}
