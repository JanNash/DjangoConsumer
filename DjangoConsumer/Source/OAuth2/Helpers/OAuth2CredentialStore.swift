//
//  OAuth2CredentialStore.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 25.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: - OAuth2CredentialStore
public protocol OAuth2CredentialStore {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var expiryDate: Date? { get set }
    var tokenType: String? { get set }
    var scope: String? { get set }
    mutating func update(with credentials: Credentials)
    mutating func clear()
}


// MARK: Default Implemetations
public extension OAuth2CredentialStore {
    typealias Credentials = (accessToken: String, refreshToken: String, expiryDate: Date, tokenType: String, scope: String)
    
    mutating func update(with credentials: Credentials) {
        self.accessToken = credentials.accessToken
        self.refreshToken = credentials.refreshToken
        self.expiryDate = credentials.expiryDate
        self.tokenType = credentials.tokenType
        self.scope = credentials.scope
    }
    
    mutating func clear() {
        self.accessToken = nil
        self.refreshToken = nil
        self.expiryDate = nil
        self.tokenType = nil
        self.scope = nil
    }
}
