//
//  OAuth2Constants.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 03.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//


// MARK: // Public
public enum OAuth2Constants {
    public enum JSONKeys {
        public static let accessToken: String   = "access_token"
        public static let refreshToken: String  = "refresh_token"
        public static let expiresIn: String     = "expires_in"
        public static let grantType: String     = "grant_type"
        public static let scope: String         = "scope"
        public static let username: String      = "username"
        public static let password: String      = "password"
        public static let token: String         = "token"
        public static let tokenType: String     = "token_type"
    }
    
    public enum GrantTypes {
        public static let password: String      = "password"
        public static let refreshToken: String  = "refresh_token"
    }
    
    public enum Scopes {
        public static let readWrite: String     = "read write"
    }
    
    public enum HeaderFields {
        public static let authorization: String = "Authorization"
    }
    
    public enum HeaderValues {
        public static func basic(_ appSecret: String) -> String    { return "Basic \(appSecret)" }
        public static func bearer(_ accessToken: String) -> String { return "Bearer \(accessToken)" }
    }
}
