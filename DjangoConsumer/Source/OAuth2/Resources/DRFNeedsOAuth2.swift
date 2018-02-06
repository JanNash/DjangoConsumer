//
//  DRFOAuth2NeedyResource.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFNeedsOAuth2 {
    static var defaultNode: DRFOAuth2Node { get }
}
