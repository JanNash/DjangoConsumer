//
//  DRFOAuth2Node.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 28.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
public protocol DRFOAuth2Node: DRFNode {
    var oauth2Handler: DRFOAuth2Handler { get }
}
