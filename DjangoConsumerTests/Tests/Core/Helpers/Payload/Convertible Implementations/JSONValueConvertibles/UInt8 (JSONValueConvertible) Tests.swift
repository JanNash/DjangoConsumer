//
//  UInt8 (JSONValueConvertible) Tests.swift
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
class UInt8_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomUInt8s() {
        let range: Range<UInt8> = 0..<100
        for _ in 0..<1000 {
            let someUInt8: UInt8 = .random(in: range)
            XCTAssertEqual(someUInt8.toJSONValue(), .uInt8(someUInt8))
        }
    }
}
