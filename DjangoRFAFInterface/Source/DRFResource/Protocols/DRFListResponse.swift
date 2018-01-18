//
//  DRFListResponse.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 18.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: // Public
public protocol DRFListResponse {
    associatedtype T: DRFListGettable
    init(json: JSON)
    var results: [T] { get }
}
