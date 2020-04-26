//
//  ExampleNoAuthNode.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 14.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: -
class ExampleNoAuthNode: NoAuthNode {
    // Shared Instance
    static let shared: ExampleNoAuthNode = ExampleNoAuthNode()
    
    // Node Conformance
    let sessionManagerNoAuth: SessionManagerType = SessionManager.makeDefault()
    let baseURL: URL = URL(string: "")!
    let routes: [Route] = []

    func defaultLimit<T>(for resourceType: T.Type) -> UInt where T : ListGettable {
        return 1000
    }
}
