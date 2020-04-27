//
//  Int (JSONValueConvertible) Tests.swift
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
class Int_JSONValueConvertible_Tests: BaseTest {
    func test1000RandomInts() {
        let tenToThePowerOfTwelve: Int = 1_000_000_000_000
        let range: Range<Int> = -tenToThePowerOfTwelve..<tenToThePowerOfTwelve
        for _ in 0..<1000 {
            let someInt: Int = .random(in: range)
            XCTAssertEqual(someInt.toJSONValue(), .int(someInt))
        }
    }
}
