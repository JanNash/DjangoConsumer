//
//  MockNode.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 21.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class MockNode: Node {
    // Singleton
    static let main: MockNode = MockNode()
    
    // Node Conformance
    // SessionManager
    let sessionManager: SessionManagerType = TestSessionManager()
    
    // Base URL
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Routes
    var routes: [Route] = [
        Route(MockListGettable.self, .list, .get, "listgettables"),
        Route(MockSinglePostable.self, .detail, .post, "singlepostables"),
    ]
    
    // Pagination
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt {
        return 1000
    }
}
