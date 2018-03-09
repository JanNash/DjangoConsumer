//
//  JSONInitializable.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 08.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import SwiftyJSON


// MARK: // Public
public protocol JSONInitializable {
    init(json: JSON)
}
