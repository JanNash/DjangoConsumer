//
//  UInt16 (JSONValueConvertible) Tests.swift
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
class UInt16_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomUInt16s() {
        let range: Range<UInt16> = 0..<10_000
        for _ in 0..<1000 {
            let someUInt16: UInt16 = .random(in: range)
            XCTAssertEqual(someUInt16.toJSONValue(), .uInt16(someUInt16))
        }
    }
}
