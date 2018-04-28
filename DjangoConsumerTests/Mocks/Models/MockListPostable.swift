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
struct MockListPostable: ListPostableNoAuth, Equatable {
    // Keys
    struct Keys {
        static let name: String = "name"
    }
    
    // Init
    init(name: String) {
        self.name = name
    }
    
    // Variables
    var name: String
    
    // ListPostable
    init(json: JSON) {
        self.name = json[Keys.name].string!
    }
    
    static let defaultNoAuthNode: NoAuthNode = MockNode.main
    static var listPostableClients: [ListPostableClient] = []
    
    func toParameters(for method: ResourceHTTPMethod) -> Parameters {
        return [Keys.name : self.name]
    }
}
