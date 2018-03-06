//
//  ListURI.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
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
