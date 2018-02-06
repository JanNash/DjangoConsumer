//
//  MockListGettableClient.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash (privat) on 23.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class MockListGettableClient: DRFListGettableClient {
    var gotObjects_: ([DRFListGettable], GETObjectListSuccess) -> Void = { _, _ in }
    var failedGettingObjects_: (GETObjectListFailure) -> Void = { _ in }
    
    func gotObjects(objects: [DRFListGettable], with success: GETObjectListSuccess) {
        self.gotObjects_(objects, success)
    }
    
    func failedGettingObjects(with failure: GETObjectListFailure) {
        self.failedGettingObjects_(failure)
    }
}
