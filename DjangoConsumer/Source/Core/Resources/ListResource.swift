//
//  ListURI.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - ListResource
public protocol ListResource {}


// MARK: - DetailURI
public struct ListURI<T: ListResource> {
    public init(_ path: String) {
        self.url = URL(string: path)!
    }
    
    public private(set) var url: URL
}
