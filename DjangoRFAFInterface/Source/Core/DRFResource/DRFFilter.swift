//
//  DRFFilter.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - DRFFilter
public typealias DRFFilter = (DRFFilterKey, DRFFilterComparator, Any?)


// MARK: - DRFFilterKey
public struct DRFFilterKey {
    // Init
    public init(_ string: String) {
        self.string = string
    }
    
    // Internal Variables
    var string: String = ""
}


// MARK: - DRFFilterComparator
public struct DRFFilterComparator {
    // Init
    public init(_ string: String) {
        self.string = string
    }
    
    // Internal Variables
    var string: String = ""
}
