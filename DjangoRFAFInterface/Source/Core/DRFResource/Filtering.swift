//
//  Filtering.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - DRFFilterKey
public protocol DRFFilterKey {
    var string: String { get }
}


// MARK: - DRFFilterComparator
public protocol DRFFilterComparator {
    var string: String { get }
}
