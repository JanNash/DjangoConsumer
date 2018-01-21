//
//  Foo.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Struct Declaration
struct Foo: DRFListGettable {
    // Init
    init(id: String, bar: String) {
        self.id = id
        self.bar = bar
    }
    
    // Keys
    struct Keys {
        static let id: String = "id"
        static let bar: String = "bar"
    }
    
    // Variables
    var id: String = "1"
    var bar: String = "A"
    
    // DRFMetaResource
    static var defaultNode: DRFNode = LocalNode()
    
    // DRFListGettable
    init(json: JSON) {
        self.id = json[Keys.id].string!
        self.bar = json[Keys.bar].string!
    }
    static let defaultLimit: UInt = 20
    static var clients: [DRFListGettableClient] = []
    
    // LocalNodeListGettable
    static let localNodeMaximumLimit: UInt = 200
    static var allFixtureObjects: [Foo] = []
}


// MARK: Protocol Conformances
// MARK: LocalNodeListGettable
extension Foo: LocalNodeListGettable {
    func toJSONDict() -> [String : Any] {
        return [
            Keys.id: self.id,
            Keys.bar: self.bar
        ]
    }
}
