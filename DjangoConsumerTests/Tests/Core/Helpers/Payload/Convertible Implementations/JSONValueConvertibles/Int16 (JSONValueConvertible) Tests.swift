//
//  Int16 (JSONValueConvertible) Tests.swift
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
class Int16_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomInt16s() {
        let aThousand: Int16 = 1_000
        let range: Range<Int16> = -aThousand..<aThousand
        for _ in 0..<1000 {
            let someInt16: Int16 = .random(in: range)
            XCTAssertEqual(someInt16.toJSONValue(), .int16(someInt16))
        }
    }
}

