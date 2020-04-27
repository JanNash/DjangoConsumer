//
//  Date (JSONValueConvertible) Tests.swift
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
class Date_JSONValueConvertible_Tests: BaseTest {
    func testNowToJSONValue() {
        let date: Date = Date()
        
        let expectedString: String = {
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return formatter.string(from: date)
        }()
        
        XCTAssertEqual(date.toJSONValue(), .string(expectedString))
    }
}
