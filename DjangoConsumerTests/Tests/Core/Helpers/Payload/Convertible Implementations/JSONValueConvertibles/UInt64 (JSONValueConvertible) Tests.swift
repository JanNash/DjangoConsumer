//
//  UInt64 (JSONValueConvertible) Tests.swift
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
class UInt64_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomUInt64s() {
        let range: Range<UInt64> = 0..<10_000_000_000_000_000_000
        for _ in 0..<1000 {
            let someUInt64: UInt64 = .random(in: range)
            XCTAssertEqual(someUInt64.toJSONValue(), .uInt64(someUInt64))
        }
    }
}
