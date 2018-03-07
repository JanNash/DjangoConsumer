//
//  DetailGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsOAuth2 {
    func get(from node: Node? = nil) {
        self.get_(from: node ?? Self.defaultNode)
    }
}
