//
//  DRFOAuth2Node.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: Protocol Declaration
public protocol DRFOAuth2Node: DRFNode {
    var oauth2Handler: DRFOAuth2Handler { get }
}


// MARK: Default Init
public extension DRFOAuth2Node {
    public init() {
        self.init()
        self.sessionManager.adapter = self.oauth2Handler
        self.sessionManager.retrier = self.oauth2Handler
    }
}
