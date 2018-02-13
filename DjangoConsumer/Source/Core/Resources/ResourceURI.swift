//
//  ResourceURI.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: -
public protocol HasAResourceURI {
    var resourceURI: URL { get }
}


// MARK: -
public struct ResourceURI<T: HasAResourceURI> {
    init(_ path: String) {
        self.resourceURI = URL(string: path)!
    }
    
    private(set) var resourceURI: URL
}
