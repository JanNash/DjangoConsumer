//
//  DetailGettable+OAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire


// MARK: // Public
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsOAuth2 {
    func get(from node: Node? = nil) {
        DefaultDetailGettableImplementations.get(self, from: node ?? Self.defaultNode)
    }
}
