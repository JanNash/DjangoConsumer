//
//  Payload.Dict (PayloadElementConvertible) Tests.swift
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
class PayloadDict_PayloadElementConvertible_Tests: BaseTest {
    func testToPayloadElementPureJSON() {
        let currentKey: String = "foo"
        let dict: Payload.Dict = Payload.Dict(["baz": true, "zoing": false])
        
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
        
        XCTAssert(json == [currentKey: ["baz": true, "zoing": false]])
    }
    
    func testToPayloadElementPureMultipart() {
        let currentKey: String = "foo"
        let bazImage: UIImage = UIImage(color: .red)
        let zoingImage: UIImage = UIImage(color: .black)
        
        let dict: Payload.Dict = Payload.Dict(["baz": bazImage, "zoing": zoingImage])
        
        let payloadElement: Payload.Element = dict.toPayloadElement(
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
            "\(currentKey).baz": (bazImage.pngData()!, .imagePNG),
            "\(currentKey).zoing": (zoingImage.pngData()!, .imagePNG),
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
    
    func testToPayloadElementMixedJSONAndMultipart() {
        let currentKey: String = "foo"
        let bazImage: UIImage = UIImage(color: .red)
        
        let dict: Payload.Dict = Payload.Dict(["baz": bazImage, "zoing": "blubb"])
        
        let payloadElement: Payload.Element = dict.toPayloadElement(
            conversion: DefaultPayloadConversion(),
            configuration: (
                rootObject: nil,
                method: .get,
                multipartPath: Payload.Multipart.Path(currentKey),
                currentKey: currentKey
            )
        )
        
        guard let json: Payload.JSON.UnwrappedPayload = payloadElement.json else {
            XCTFail("payloadElement should contain json")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [
            currentKey: ["zoing": "blubb"]
        ]
        
        XCTAssert(json == expectedJSON)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "\(currentKey).baz": (bazImage.pngData()!, .imagePNG),
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
}
