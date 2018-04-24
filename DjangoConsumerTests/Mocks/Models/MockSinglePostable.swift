//
//  MockSinglePostable.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash on 07.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import SwiftyJSON
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Struct Declaration
struct MockSinglePostable: SinglePostable, NeedsNoAuth {
    // Init
    init() {}
    
    // Keys
    struct Keys {}
    
    // SinglePostable
    init(json: JSON) {}
    
    static var defaultNode: Node = MockNode.main
    static var singlePostableClients: [SinglePostableClient] = []
    
    func toParameters(for method: ResourceHTTPMethod) -> Parameters {
        return [:]
    }
}
