//
//  Dictionary (PayloadElementConvertible) Tests.swift
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
class Dictionary_PayloadElementConvertible_Tests: BaseTest {
    func testNestedDictionaryPureJSON() {
        let currentKey: String = "foo"
        let dict: Payload.Dict = ["bar": ["baz": true, "zoing": false]]
        
        let payloadElement: Payload.Element = dict.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssert(payloadElement.multipart.isEmpty)
        
        guard let json: Payload.JSON.UnwrappedPayload = payloadElement.json else {
            XCTFail("payloadElement should contain json")
            return
        }
        
        XCTAssert(json == ["foo": ["bar": ["baz": true, "zoing": false]]])
    }
}
