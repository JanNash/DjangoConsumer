//
//  MockListGettableClient.swift
//  DjangoRFAFInterfaceTests
//
//  Created by Jan Nash on 23.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import DjangoConsumer


// MARK: // Internal
// MARK: Class Declaration
class MockListGettableClient: ListGettableClient {
    var gotObjects_: ([ListGettable], GETObjectListSuccess) -> Void = { _, _ in }
    var failedGettingObjects_: (GETObjectListFailure) -> Void = { _ in }
    
    func gotObjects(objects: [ListGettable], with success: GETObjectListSuccess) {
        self.gotObjects_(objects, success)
    }
    
    func failedGettingObjects(with failure: GETObjectListFailure) {
        self.failedGettingObjects_(failure)
    }
}
