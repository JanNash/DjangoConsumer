//
//  Array (PayloadElementConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 26.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import DjangoConsumer


// MARK: -
class Array_PayloadElementConvertible_Tests: BaseTest {
    func testToPayloadElementPureJSON() {
        let currentKey: String = "bar"
        let ary: [String] = ["a", "b", "c"]
        let payloadElement: Payload.Element = ary.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssert(payloadElement.multipart == nil)
        
        guard let json: Payload.JSON.UnwrappedPayload = payloadElement.json else {
            XCTFail("payloadElement does not contain json payload")
            return
        }
        
        XCTAssert(json == [currentKey: ary])
    }
    
    func testToPayloadElementPureMultipart() {
        let currentKey: String = "bar"
        let ary: [UIImage] = [UIImage(color: .red), UIImage(color: .green), UIImage(color: .blue)]
        let payloadElement: Payload.Element = ary.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssert(payloadElement.json == nil)
        
        guard let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart else {
            XCTFail("payloadElement does not contain multipart payload")
            return
        }
        
//        XCTAssert(multipart == )
    }
}
