//
//  DRFOAuth2Node.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFOAuth2Node: DRFNode {
    // OAuth2 Setup
    var appSecret: String { get }
    var tokenRequestEndpoint: URL { get }
    var tokenRefreshEndpoint: URL { get }
    var tokenRevokeEndpoint: URL { get }
    
    // OAuth2 State
    var accessToken: String { get }
    var refreshToken: String { get }
    var grantType: String { get }
}
