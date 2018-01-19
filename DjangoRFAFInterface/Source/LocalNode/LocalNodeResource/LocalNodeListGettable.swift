//
//  LocalNodeListGettable.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol LocalNodeListGettable: DRFListGettable {
    static var localNodeMaximumLimit: UInt { get }
    static var allFixtureObjects: [Self] { get }
    func toJSONDict() -> [String : Any]
}
