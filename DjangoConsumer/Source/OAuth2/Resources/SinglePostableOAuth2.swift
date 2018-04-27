//
//  SinglePostableOAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 06.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: Protocol Declaration
public protocol SinglePostableOAuth2: SinglePostable {
    static var singlePOSTdefaultNode: OAuth2Node { get }
}


// MARK: Default Implementations
public extension SinglePostableOAuth2 {
    func post(to node: OAuth2Node = Self.singlePOSTdefaultNode) {
        DefaultImplementations._SinglePostable_.post(
            self, to: node, via: node.oauth2Handler.authenticatedSessionManager, additionalHeaders: [:], additionalParameters: [:]
        )
    }
}
