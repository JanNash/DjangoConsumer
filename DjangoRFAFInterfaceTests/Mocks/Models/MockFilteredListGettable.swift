//
//  MockFilteredListGettable.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 24.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Struct Declaration
struct MockFilteredListGettable: DRFFilteredListGettable, DRFNeedsNoAuth {
    // Init
    init(id: String, date: Date, name: String) {
        self.id = id
        self.date = date
        self.name = name
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
        static let date: String = "date"
        static let name: String = "name"
    }
    
    // Variables
    private(set) var id: String = "0"
    private(set) var date: Date = Date()
    private(set) var name: String = "A"
    
    // DRFListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
        self.date = json[Keys.date].string!.date(format: .iso8601(options: .withInternetDateTime))!.absoluteDate
        self.name = json[Keys.name].string!
    }
    
    static var defaultNode: DRFNode = TestNode.main
    static var clients: [DRFListGettableClient] = []
}
