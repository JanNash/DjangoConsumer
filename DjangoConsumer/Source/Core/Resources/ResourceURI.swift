//
//  ResourceURI.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - HasAResourceURI
public protocol HasAResourceURI {
    var resourceURI: ResourceURI<Self> { get }
}


// MARK: - ResourceURI
public struct ResourceURI<T: HasAResourceURI> {
    public init(_ path: String) {
        self.url = URL(string: path)!
    }
    
    public private(set) var url: URL
}
