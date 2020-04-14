//
//  ExampleOAuth2Node.swift
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
class ExampleOAuth2Node: OAuth2Node {
    // Shared Instance
    static let shared: ExampleOAuth2Node()
    
    // Node Conformance
    let sessionManagerNoAuth: SessionManagerType = SessionManager.makeDefault()
    let baseURL: URL = URL(string: "")!
    let routes: [Route] = []
    
    func defaultLimit<T>(for resourceType: T.Type) -> UInt where T : ListGettable {
        return 1000
    }
    
    // OAuth2Node Conformance
    var oauth2Clients: [OAuth2NodeAuthenticationClient] = []
    
    lazy var oauth2Handler: OAuth2Handler = {
        let baseURL: URL = self.baseURL
        let settings: OAuth2Settings = OAuth2Settings(
            appSecret: "",
            tokenRequestURL: baseURL + "",
            tokenRefreshURL: baseURL + "",
            tokenRevokeURL: baseURL + ""
        )
        return OAuth2Handler(settings: settings, credentialStore: ExampleOAuth2CredentialStore.shared)
    }()
}


// MARK: -
struct ExampleOAuth2CredentialStore: OAuth2CredentialStore {
    // Shared Instance
    static let shared: ExampleOAuth2CredentialStore = ExampleOAuth2CredentialStore()
    
    // Variables
    var accessToken: String?
    var refreshToken: String?
    var expiryDate: Date?
    var tokenType: String?
    var scope: String?
    
    // Functions
    mutating func updateWith(accessToken: String, refreshToken: String, expiryDate: Date, tokenType: String, scope: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiryDate = expiryDate
        self.tokenType = tokenType
        self.scope = scope
    }
    
    mutating func clear() {
        self.accessToken = nil
        self.refreshToken = nil
        self.expiryDate = nil
        self.tokenType = nil
        self.scope = nil
    }
}
