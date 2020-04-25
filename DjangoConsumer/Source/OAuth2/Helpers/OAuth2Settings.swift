//
//  OAuth2Settings.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 25.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - OAuth2Settings
// MARK: ???: Should this be a protocol, too? Check RFC
public struct OAuth2Settings {
    // Init
    public init(appSecret: String, tokenRequestURL: URL, tokenRefreshURL: URL, tokenRevokeURL: URL) {
        self.appSecret = appSecret
        self.tokenRequestURL = tokenRequestURL
        self.tokenRefreshURL = tokenRefreshURL
        self.tokenRevokeURL = tokenRevokeURL
    }
    
    // Public Variables
    public private(set) var appSecret: String
    public private(set) var tokenRequestURL: URL
    public private(set) var tokenRefreshURL: URL
    public private(set) var tokenRevokeURL: URL
}
