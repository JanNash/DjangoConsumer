//
//  OAuth2Node.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - OAuth2NodeAuthenticationClient
public protocol OAuth2NodeAuthenticationClient {
    func authenticated(node: OAuth2Node)
    func failedAuthenticating(node: OAuth2Node, with error: Error)
    func refreshedAuthentication(for node: OAuth2Node)
    func failedRefreshingAuthenticaiton(for node: OAuth2Node, with error: Error)
    func endedAuthentication(for node: OAuth2Node)
}

// MARK: - OAuth2Node
// MARK: Protocol Declaration
public protocol OAuth2Node: Node {
    var oauth2Clients: [OAuth2NodeAuthenticationClient] { get }
    var oauth2Handler: OAuth2Handler { get }
}


// MARK: Default Init
public extension OAuth2Node {
    public init() {
        self.init()
        self.sessionManager.adapter = self.oauth2Handler
        self.sessionManager.retrier = self.oauth2Handler
    }
}


// MARK: Authentication Forwarding
public extension OAuth2Node {
    public func authenticate(username: String, password: String) {
        self._authenticate(username: username, password: password)
    }
    
    public func refreshAuthentication() {
        self._refreshAuthentication()
    }
    
    public func endAuthentication() {
        self._endAuthentication()
    }
}


// MARK: // Private
// MARK: Authentication Forwarding Implementations
private extension OAuth2Node {
    func _authenticate(username: String, password: String) {
        self.oauth2Handler.requestTokens(
            username: username,
            password: password,
            success: { self.oauth2Clients.forEach({ $0.authenticated(node: self) }) },
            failure: { error in
                self.oauth2Clients.forEach({ $0.failedAuthenticating(node: self, with: error) })
            }
        )
    }
    
    func _refreshAuthentication() {
        self.oauth2Handler.refreshTokens(
            success: { self.oauth2Clients.forEach({ $0.refreshedAuthentication(for: self) }) },
            failure: { error in
                self.oauth2Clients.forEach({ $0.failedRefreshingAuthenticaiton(for: self, with: error) })
            }
        )
    }
    
    func _endAuthentication() {
        self.oauth2Handler.revokeTokens()
        self.oauth2Clients.forEach({ $0.endedAuthentication(for: self) })
    }
}
