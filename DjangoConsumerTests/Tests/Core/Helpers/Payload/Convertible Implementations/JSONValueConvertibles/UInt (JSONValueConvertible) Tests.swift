//
//  UInt (JSONValueConvertible) Tests.swift
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
class UInt_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomUInts() {
        let range: Range<UInt> = 0..<1_000_000_000_000_000_000
        for _ in 0..<1000 {
            let someUInt: UInt = .random(in: range)
            XCTAssertEqual(someUInt.toJSONValue(), .uInt(someUInt))
        }
    }
}
