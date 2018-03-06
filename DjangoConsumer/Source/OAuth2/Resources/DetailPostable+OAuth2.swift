//
//  DetailPostable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 06.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsOAuth2
public extension DetailPostable where Self: NeedsOAuth2 {
    func post(to node: OAuth2Node? = nil) {
        self.post_(to: node ?? Self.defaultNode)
    }
}
