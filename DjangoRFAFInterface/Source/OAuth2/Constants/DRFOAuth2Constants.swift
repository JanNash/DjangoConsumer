//
//  DRFOAuth2Constants.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 03.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public struct DRFOAuth2Constants {
    public struct JSONKeys {
        public static let accessToken: String   = "access_token"
        public static let refreshToken: String  = "refresh_token"
        public static let expiresIn: String     = "expires_in"
        public static let grantType: String     = "grant_type"
        public static let scope: String         = "scope"
    }
    
    public struct GrantTypes {
        public static let password: String      = "password"
        public static let refreshToken: String  = "refresh_token"
    }
    
    public struct Scopes {
        public static let readWrite: String     = "read write"
    }
    
    public struct HeaderFields {
        public static let authorization: String = "Authorization"
    }
    
    public struct HeaderValues {
        public static func basic(_ appSecret: String) -> String    { return "Basic \(appSecret)" }
        public static func bearer(_ accessToken: String) -> String { return "Bearer \(accessToken)" }
    }
}
