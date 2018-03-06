//
//  NeedsNoAuth.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol NeedsNoAuth {
    static var defaultNode: Node { get }
}
