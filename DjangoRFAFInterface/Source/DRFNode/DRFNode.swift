//
//  DRFNode.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFNode {
    var baseURL: URL { get }
    func listEndpoint<T: DRFListGettable>(for resourceType: T.Type) -> URL
}
