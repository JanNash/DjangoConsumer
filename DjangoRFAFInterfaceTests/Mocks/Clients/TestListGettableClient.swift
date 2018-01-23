//
//  TestListGettableClient.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 23.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoRFAFInterface


// MARK: // Internal
// MARK: Class Declaration
class TestListGettableClient: DRFListGettableClient {
    func gotObjects<T>(objects: [T], with success: GETObjectListSuccess<T>) {}
    func failedGettingObjects<T>(with failure: GETObjectListFailure<T>) {}
}
