//
//  OAuth2Node.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
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


// MARK: Authentication Forwarding
public extension OAuth2Node {
    public func authenticate(username: String, password: String) {
        DefaultOAuth2NodeImplementations.authenticate(node: self, username: username, password: password)
    }
    
    public func refreshAuthentication() {
        DefaultOAuth2NodeImplementations.refreshAuthentication(node: self)
    }
    
    public func endAuthentication() {
        DefaultOAuth2NodeImplementations.endAuthentication(node: self)
    }
}


// MARK: - DefaultOAuth2NodeImplementations
public struct DefaultOAuth2NodeImplementations {
    public static func authenticate(node: OAuth2Node, username: String, password: String) {
        self._authenticate(node: node, username: username, password: password)
    }
    
    public static func refreshAuthentication(node: OAuth2Node) {
        self._refreshAuthentication(node: node)
    }
    
    public static func endAuthentication(node: OAuth2Node) {
        self._endAuthentication(node: node)
    }
}


// MARK: // Private
private extension DefaultOAuth2NodeImplementations {
    static func _authenticate(node: OAuth2Node, username: String, password: String) {
        node.oauth2Handler.requestTokens(
            username: username,
            password: password,
            success: { node.oauth2Clients.forEach({ $0.authenticated(node: node) }) },
            failure: { error in
                node.oauth2Clients.forEach({ $0.failedAuthenticating(node: node, with: error) })
            }
        )
    }
    
    static func _refreshAuthentication(node: OAuth2Node) {
        node.oauth2Handler.refreshTokens(
            success: { node.oauth2Clients.forEach({ $0.refreshedAuthentication(for: node) }) },
            failure: { error in
                node.oauth2Clients.forEach({ $0.failedRefreshingAuthenticaiton(for: node, with: error) })
            }
        )
    }
    
    static func _endAuthentication(node: OAuth2Node) {
        node.oauth2Handler.revokeTokens()
        node.oauth2Clients.forEach({ $0.endedAuthentication(for: node) })
    }
}
