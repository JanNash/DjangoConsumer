//
//  MockBackendListGettable.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire


// MARK: // Public
public protocol MockBackendListGettable: DRFListGettable {
    static func mockBackendFilterClosure(for queryParameters: Parameters) -> ((Self) -> Bool)
    func mockBackendToJSONDict() -> [String : Any]
}
