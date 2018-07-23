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
    func testPayloadFromMultipartArrayWithSomeValuesThatProduceNilDataAndSomeThatProduceActualData() {
        let payloadDict: Payload.Dict = Payload.Dict([
            "images": [
                UIImage(), // UIImagePNGRepresentation() will produce nil data for this
                UIImage(color: .clear) // UIImagePNGRepresentation() will produce actual data for this
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
}
