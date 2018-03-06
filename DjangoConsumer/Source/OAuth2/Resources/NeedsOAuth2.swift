//
//  OAuth2NeedyResource.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol NeedsOAuth2 {
    static var defaultNode: OAuth2Node { get }
}
