//
//  DRFOAuth2Handler.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: Protocl Declaration
public protocol DRFOAuth2Handler {
    // Setup
    var appSecret: String { get }
    var tokenRequestEndpoint: URL { get }
    var tokenRefreshEndpoint: URL { get }
    var tokenRevokeEndpoint: URL { get }
    
    // State
    var accessToken: String { get }
    var refreshToken: String { get }
    var grantType: String { get }
}
