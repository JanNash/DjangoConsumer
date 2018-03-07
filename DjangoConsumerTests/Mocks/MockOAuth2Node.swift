//
//  TestOAuth2Node.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 06.02.18.
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
class MockOAuth2Node: OAuth2Node {
    // Singleton
    static let main: MockOAuth2Node = MockOAuth2Node()
    
    // Node Conformance
    // Basic Setup
    var baseURL: URL = URL(string: "http://localhost:8080")!
    
    // SessionManager
    let sessionManager: SessionManagerType = TestSessionManager()
    
    // Pagination
    func defaultLimit<T: ListGettable>(for resourceType: T.Type) -> UInt {
        return 1000
    }
    
    // List GET endpoints
    func relativeListURL<T: ListResource>(for resourceType: T.Type, method: HTTPMethod) -> URL {
        return self._relativeListURL(for: resourceType, method: method)
    }
    
    // Single POST endpoints
    func relativeSinglePOSTURL<T>(for resourceType: T.Type) -> URL where T : SinglePostable {
        return self._relativeSinglePOSTURL(for: resourceType)
    }
    
    // OAuth2Node Conformance
    // OAuth2Clients
    var oauth2Clients: [OAuth2NodeAuthenticationClient] = []
    
    // OAuth2Handler
    lazy var oauth2Handler: OAuth2Handler = {
        let baseURLWith: (String) -> URL = self.baseURL.appendingPathComponent
        
        let settings: OAuth2Settings = OAuth2Settings(
            appSecret: "",
            tokenRequestURL: baseURLWith(""),
            tokenRefreshURL: baseURLWith(""),
            tokenRevokeURL: baseURLWith("")
        )
        
        return OAuth2Handler(
            settings: settings,
            credentialStore: TestOAuth2CredentialStore()
        )
    }()
}


// MARK: // Private
// MARK: Node Implementations
// MARK: List GET endpoints
private extension MockOAuth2Node {
    func _relativeListURL<T: ListResource>(for resourceType: T.Type, method: HTTPMethod) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == MockListGettable.self {
            return URL(string: "listgettables/")!
        } else if resourceType == MockFilteredListGettable.self {
            return URL(string: "filteredlistgettables/")!
        }
        // FIXME: Throw a real Error here?
        fatalError("[MockOAuth2Node] No relativeListURL registered for '\(resourceType)' with method '\(method)'")
    }
}


// MARK: Single POST endpoints
private extension MockOAuth2Node {
    func _relativeSinglePOSTURL<T>(for resourceType: T.Type) -> URL where T : SinglePostable {
        if resourceType == MockSinglePostable.self {
            return URL(string: "singlepostables/")!
        }
        
        fatalError("[MockOAuth2Node] No singlePOSTURL registered for '\(resourceType)'")
    }
}
