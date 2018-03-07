//
//  MockSinglePostable.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockSinglePostable: SinglePostable, NeedsNoAuth {
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
    
    // SinglePostable
    init(json: JSON) {
        self.id = json[Keys.id].string!
    }
    
    static var defaultNode: Node = MockNode.main
    static var singlePostableClients: [SinglePostableClient] = []
    
    func toParameters() -> Parameters {
        return [Keys.id : self.id]
    }
}
