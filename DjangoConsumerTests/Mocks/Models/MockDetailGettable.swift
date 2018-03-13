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
struct MockDetailGettable: DetailGettable, NeedsNoAuth {
    // Keys
    struct Keys {
        static let id: String = "id"
    }
    
    // Init
    init(id: ResourceID<MockDetailGettable>) {
        self.id = id
    }
    
    // SinglePostable
    init(json: JSON) {
        self.id = ResourceID(json[Keys.id].string!)
    }
    
    static var defaultNode: Node = MockNode.main
    static var detailGettableClients: [DetailGettableClient] = []
    
    var id: ResourceID<MockDetailGettable>
    
    func gotNewSelf(_ newSelf: MockDetailGettable, from: Node) {}
    func failedGettingNewSelf(from: Node, with error: Error) {}
}
