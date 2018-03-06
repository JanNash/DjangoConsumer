//
//  DetailPostable+OAuth2.swift
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
// MARK: where Self: NeedsOAuth2
public extension DetailPostable where Self: NeedsOAuth2 {
    func post(to node: OAuth2Node? = nil) {
        self.post_(to: node ?? Self.defaultNode)
    }
}
