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
        
        XCTAssert(payloadElement.multipart.isEmpty)
        
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
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "\(currentKey)[0]": (ary[0].pngData()!, .imagePNG),
            "\(currentKey)[1]": (ary[1].pngData()!, .imagePNG),
            "\(currentKey)[2]": (ary[2].pngData()!, .imagePNG),
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
    
    func testToPayloadElementPureMultipartContainingNull() {
        let currentKey: String = "bar"
        let ary: [UIImage] = [UIImage(), UIImage(color: .green), UIImage(color: .blue)]
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
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "bar[0]": ("null".data(using: .utf8)!, .imagePNG),
            "bar[1]": (ary[1].pngData()!, .imagePNG),
            "bar[2]": (ary[2].pngData()!, .imagePNG),
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
    
    func testToPayloadElementMixedJSONAndMultipart() {
        let currentKey: String = "bar"
        let aImages: [UIImage] = [UIImage(), UIImage(color: .green), UIImage(color: .blue)]
        let cImages: [UIImage] = [UIImage(), UIImage(color: .green), UIImage(color: .blue)]
        
        let dict: [Payload.Dict] = [
            Payload.Dict([
                "a": "b",
                "aImages": aImages
            ]),
            Payload.Dict([
                "c": "d",
                "cImages": cImages
            ])
        ]
        
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
            XCTFail("payloadElement does not contain json payload")
            return
        }
        
        let expectedJSON: Payload.JSON.UnwrappedPayload = [
            "bar": [
                ["a": "b"],
                ["c": "d"]
            ]
        ]
        
        XCTAssert(json == expectedJSON)
        
        let expectedMultipart: Payload.Multipart.UnwrappedPayload = [
            "bar[0]aImages[0]": ("null".data(using: .utf8)!, .imagePNG),
            "bar[0]aImages[1]": (aImages[1].pngData()!, .imagePNG),
            "bar[0]aImages[2]": (aImages[2].pngData()!, .imagePNG),
            "bar[1]cImages[0]": ("null".data(using: .utf8)!, .imagePNG),
            "bar[1]cImages[1]": (cImages[1].pngData()!, .imagePNG),
            "bar[1]cImages[2]": (cImages[2].pngData()!, .imagePNG),
        ]
        
        XCTAssert(payloadElement.multipart == expectedMultipart)
    }
}
