//
//  String (JSONValueConvertible) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class String_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomStrings() {
        for _ in 0..<1000 {
            let someString: String = UUID().uuidString
            XCTAssertEqual(someString.toJSONValue(), .string(someString))
        }
    }
}
