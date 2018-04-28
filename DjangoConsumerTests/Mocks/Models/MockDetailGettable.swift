//
//  MockDetailGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import SwiftyJSON
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockDetailGettable: DetailGettableNoAuth {
    // ID typealias
    typealias ID = ResourceID<MockDetailGettable>
    
    // Keys
    struct Keys {
        static let id: String = "id"
    }
    
    // Init
    init(id: ID?) {
        self.id = id
    }
    
    // SinglePostable
    init(json: JSON) {
        self.id = ID(json[Keys.id].string!)
    }
    
    var id: ID?
    
    static let defaultNoAuthNode: NoAuthNode = MockNode.main
    static var detailGettableClients: [DetailGettableClient] = []
    
    func gotNewSelf(_ newSelf: MockDetailGettable, from: Node) {}
    func failedGettingNewSelf(from: Node, with error: Error) {}
}
