//
//  DRFNeedsNoAuth.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFNeedsNoAuth {
    static var defaultNode: DRFNode { get }
}
