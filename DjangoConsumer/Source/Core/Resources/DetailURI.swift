//
//  DetailURI.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: - HasADetailURI
public protocol DetailResource {
    var detailURI: DetailURI<Self> { get }
}


// MARK: - DetailURI
public struct DetailURI<T: DetailResource> {
    public init(_ path: String) {
        self.url = URL(string: path)!
    }
    
    public private(set) var url: URL
}
