//
//  TestOAuth2Node.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 06.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
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
    
    // Alamofire SessionManager
    // This is copied from the SessionManager implementation
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    // Pagination
    func defaultLimit<T>(for resourceType: T.Type) -> UInt where T : ListGettable {
        return 1000
    }
    
    // List GET endpoints
    func relativeListURL<T: ListGettable>(for resourceType: T.Type) -> URL {
        return self._relativeListURL(for: resourceType)
    }
}


// MARK: // Private
// MARK: Node Implementations
private extension MockOAuth2Node {
    func _relativeListURL<T: ListGettable>(for resourceType: T.Type) -> URL {
        // ???: Didn't get a switch to work properly, what is the right syntax?
        if resourceType == MockListGettable.self {
            return URL(string: "listgettables/")!
        } else if resourceType == MockFilteredListGettable.self {
            return URL(string: "filteredlistgettables/")!
        }
        // FIXME: Throw a real Error here?
        fatalError("[MockOAuth2Node] No URL registered for '\(resourceType)'")
    }
}
