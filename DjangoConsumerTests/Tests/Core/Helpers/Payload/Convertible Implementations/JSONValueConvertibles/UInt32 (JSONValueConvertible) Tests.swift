//
//  UInt32 (JSONValueConvertible) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 28.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class UInt32_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomUInt32s() {
        let range: Range<UInt32> = 0..<1_000_000_000
        for _ in 0..<1000 {
            let someUInt32: UInt32 = .random(in: range)
            XCTAssertEqual(someUInt32.toJSONValue(), .uInt32(someUInt32))
        }
    }
}
