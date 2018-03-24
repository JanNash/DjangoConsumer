//
//  MockListPostable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
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
struct MockListPostable: ListPostable, NeedsNoAuth {
    // Init
    init() {}
    
    // Keys
    struct Keys {}
    
    // ListPostable
    init(json: JSON) {}
    
    static var defaultNode: Node = MockNode.main
    static var listPostableClients: [ListPostableClient] = []
    
    func toParameters() -> Parameters {
        return [:]
    }
}
