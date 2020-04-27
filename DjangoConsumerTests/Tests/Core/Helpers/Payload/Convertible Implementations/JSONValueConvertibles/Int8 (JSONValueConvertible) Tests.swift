//
//  Int8 (JSONValueConvertible) Tests.swift
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
class Int8_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomInt8s() {
        let aHundred: Int8 = 100
        let range: Range<Int8> = -aHundred..<aHundred
        for _ in 0..<1000 {
            let someInt8: Int8 = .random(in: range)
            XCTAssertEqual(someInt8.toJSONValue(), .int8(someInt8))
        }
    }
}
