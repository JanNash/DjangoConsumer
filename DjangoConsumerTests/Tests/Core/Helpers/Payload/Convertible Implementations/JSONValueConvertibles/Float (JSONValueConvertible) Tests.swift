//
//  Float (JSONValueConvertible) Tests.swift
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
class Float_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomFloats() {
        let tenToThePowerOfNine: Float = 1_000_000_000
        let range: Range<Float> = -tenToThePowerOfNine..<tenToThePowerOfNine
        for _ in 0..<1000 {
            let someFloat: Float = .random(in: range)
            XCTAssertEqual(someFloat.toJSONValue(), .float(someFloat))
        }
    }
}
