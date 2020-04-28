//
//  Optional (PayloadElementConvertible) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 28.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: -
class Optional_PayloadElementConvertible_Tests: BaseTest {
    func testOptionalMultipartConvertibleWithNilValue() {
        let currentKey: String = "foo"
        let imageOptional: UIImage? = nil
        // No optional chaining needs to be used here since this is an extension on Optional itself
        let payloadElement: Payload.Element = imageOptional.toPayloadElement(
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
            XCTFail("payloadElement must contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = ["foo": NSNull()]
        
        XCTAssert(json == expectedJSON)
    }
    
    func testOptionalMultipartConvertibleWithSomeValue() {
        let currentKey: String = "foo"
        let imageOptional: UIImage? = UIImage(color: .red)
        // No optional chaining needs to be used here since this is an extension on Optional itself
        let payloadElement: Payload.Element = imageOptional.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        XCTAssertNil(payloadElement.json)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "foo": (UIImage(color: .red).pngData()!, .imagePNG)
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
}
