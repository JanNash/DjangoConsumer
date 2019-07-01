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
    func testPayloadMultipartContentTypeNull() {
        typealias FixtureType = Payload.Multipart
        
        let expectedNull: Data = "null".data(using: .utf8)!
        
        FixtureType.ContentType.allCases.forEach({
            XCTAssert($0.null == (expectedNull, $0))
        })
    }
    
    // Clarification:
    // UIImagePNGRepresentation returns nil when passed an empty image: UIImage()
    func testPayloadFromMultipartArrayWithOneValueThatProducesNilDataAndOneValueThatProducesActualData() {
        let payloadDict: Payload.Dict = Payload.Dict([
            "images": [
                UIImage(),
                UIImage(color: .clear),
            ]
        ])
        
        let payload: Payload = payloadDict._payload()
        
        XCTAssert(payload.json.isEmpty)
        
        let expectedMultipartPayload: Payload.Multipart.UnwrappedPayload = [
            "images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG)
        ]
        
        XCTAssert(payload.multipart == expectedMultipartPayload)
    }
    
    func testPayloadFromDictContainingMultipartArrays1() {
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
        
        let payload: Payload = payloadDict._payload()
        
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
        
        // Why? Wouldn't one expect the null images to be inside the json?
        // This possibly better variant can be found in the next test.
        let expectedMultipartPayload: Payload.Multipart.UnwrappedPayload = [
            "a[0]images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "a[0]images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
            "a[1]images[0]": Payload.Multipart.ContentType.imagePNG.null,
            "a[1]images[1]": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
            "a[1]image": (UIImagePNGRepresentation(UIImage(color: .clear))!, .imagePNG),
        ]
        
        XCTAssert(payload.multipart == expectedMultipartPayload)
    }
    
    func testPayloadFromDictContainingMultipartArrays2() {
        // Optionals and actual nil values instead of empty data don't work yet:
//        let optionalImage: UIImage?
        
        let payloadDict: Payload.Dict = Payload.Dict([
            "a": [
                Payload.Dict([
                    "text": "foo",
//                    "image": nil
//                    "image": optionalImage,
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
        
        let payload: Payload = payloadDict._payload()
        
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


// MARK: Payload Equality Tests
extension PayloadTests {
    func testPayloadJSONUnwrappedEqual1() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA == payloadB)
    }
    
    func testPayloadJSONUnwrappedEqual2() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": ["b": "c"]
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": ["b": "c"]
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA == payloadB)
    }
}


// MARK: Payload Inequality Tests
extension PayloadTests {
    func testPayloadJSONUnwrappedNotEqual1() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": [
                "b"
            ]
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": [
                "c"
            ]
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
    
    func testPayloadJSONUnwrappedNotEqual2() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": "b",
            "c": "d"
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
    
    func testPayloadJSONUnwrappedNotEqual3() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "c": "d"
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
    
    func testPayloadJSONUnwrappedNotEqual4() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": ["b": "c"]
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
    
    func testPayloadJSONUnwrappedNotEqual5() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": [["b": "c"]]
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": "b"
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
    
    func testPayloadJSONUnwrappedNotEqual6() {
        let payloadDictA: Payload.Dict = Payload.Dict([
            "a": [["b": "c"]]
        ])
        
        let payloadDictB: Payload.Dict = Payload.Dict([
            "a": [["b": "d"]]
        ])
        
        let payloadA: Payload = payloadDictA._payload()
        let payloadB: Payload = payloadDictB._payload()
        
        XCTAssert(payloadA != payloadB)
    }
}


// MARK: // Private
// MARK: Helpers
private extension Payload.Dict {
    func _payload() -> Payload {
        return self.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
    }
}
