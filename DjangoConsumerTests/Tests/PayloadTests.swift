//
//  PayloadTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 22.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
@testable import DjangoConsumer


// MARK: // Internal
class PayloadTests: XCTestCase {
    // Clarification:
    // UIImagePNGRepresentation returns nil when passed an empty image: UIImage()
    
    func testPayloadFromMultipartArrayWithOneValueThatProducesNilDataAndOneValueThatProducesActualData() {
        let payloadDict: Payload.Dict = Payload.Dict([
            "images": [
                UIImage(),
                UIImage(color: .clear),
            ]
        ])
        
        let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
        
        XCTAssert(payload.json.isEmpty)
        
        let expectedMultipartPayload: Payload.Multipart.UnwrappedPayload = [
            "images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG)
        ]
        
        XCTAssert(payload.multipart == expectedMultipartPayload)
    }
    
    func testPayloadFromDictContainingMultipartArrays() {
        let payloadDict: Payload.Dict = Payload.Dict([
            "a": [
                Payload.Dict([
                    "text": "foo",
                    "image": UIImage(),
                    "images": [
                        UIImage(),
                        UIImage(color: .clear)
                    ]
                ]),
                Payload.Dict([
                    "text": "bar",
                    "image": UIImage(color: .clear),
                    "images": [
                        UIImage(),
                        UIImage(color: .clear)
                    ]
                ])
            ]
        ])
        
        let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
        
        let expectedJSONPayload: Payload.JSON.UnwrappedPayload = [
            "a": [
                [
                    "text": "foo",
                    "image": NSNull()
                ],
                [
                    "text": "bar"
                ]
            ]
        ]
        
        XCTAssert(payload.json == expectedJSONPayload)
        
        let expectedMultipartPayload: Payload.Multipart.UnwrappedPayload = [
            "a[0]images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "a[0]images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
            "a[1]images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "a[1]images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
            "a[1]image": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
        ]
        
        XCTAssert(payload.multipart == expectedMultipartPayload)
    }
}
