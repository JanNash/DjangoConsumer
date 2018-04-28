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


// MARK: // Public
// MARK: - OAuth2NodeAuthenticationClient
public protocol OAuth2NodeAuthenticationClient {
    func authenticated(node: OAuth2Node)
    func failedAuthenticating(node: OAuth2Node, with error: Error)
    func refreshedAuthentication(for node: OAuth2Node)
    func failedRefreshingAuthentication(for node: OAuth2Node, with error: Error)
    func endedAuthentication(for node: OAuth2Node)
}


// MARK: - OAuth2Node
// MARK: Protocol Declaration
public protocol OAuth2Node: Node {
    var sessionManagerOAuth2: SessionManagerType { get }
    var oauth2Handler: OAuth2Handler { get }
    var oauth2Clients: [OAuth2NodeAuthenticationClient] { get }
}


// MARK: SessionManager
public extension OAuth2Node {
    public var sessionManagerOAuth2: SessionManagerType {
        return DefaultImplementations.OAuth2Node.sessionManagerOAuth2(node: self)
    }
}


// MARK: Authentication Forwarding
public extension OAuth2Node {
    public func authenticate(username: String, password: String) {
        DefaultImplementations.OAuth2Node.authenticate(node: self, username: username, password: password)
    }
    
    public func refreshAuthentication() {
        DefaultImplementations.OAuth2Node.refreshAuthentication(node: self)
    }
    
    public func endAuthentication() {
        DefaultImplementations.OAuth2Node.endAuthentication(node: self)
    }
}


// MARK: - DefaultImplementations.OAuth2Node
// MARK: SessionManager
public extension DefaultImplementations.OAuth2Node {
    public static func sessionManagerOAuth2(node: OAuth2Node) -> SessionManagerType {
        return node.oauth2Handler.authenticatedSessionManager
    }
}


// MARK: Authentication Forwarding
public extension DefaultImplementations.OAuth2Node {
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
private extension DefaultImplementations.OAuth2Node {
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
                node.oauth2Clients.forEach({ $0.failedRefreshingAuthentication(for: node, with: error) })
            }
        )
    }
    
    static func _endAuthentication(node: OAuth2Node) {
        node.oauth2Handler.revokeTokens()
        node.oauth2Clients.forEach({ $0.endedAuthentication(for: node) })
    }
}
