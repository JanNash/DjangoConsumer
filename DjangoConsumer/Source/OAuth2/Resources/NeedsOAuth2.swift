//
//  OAuth2NeedyResource.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public protocol NeedsOAuth2 {
    static var defaultNode: OAuth2Node { get }
}
