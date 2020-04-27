//
//  Int32 (JSONValueConvertible) Tests.swift
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
class Int32_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomInt32s() {
        let aMillion: Int32 = 1_000_000
        let range: Range<Int32> = -aMillion..<aMillion
        for _ in 0..<1000 {
            let someInt32: Int32 = .random(in: range)
            XCTAssertEqual(someInt32.toJSONValue(), .int32(someInt32))
        }
    }
}
