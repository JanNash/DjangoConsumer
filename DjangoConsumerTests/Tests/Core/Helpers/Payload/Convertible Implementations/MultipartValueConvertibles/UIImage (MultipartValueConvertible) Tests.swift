//
//  UIImage (MultipartValueConvertible) Tests.swift
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
class UIImage_MultipartValueConvertible_Tests: BaseTest {
    func testEmptyImage() {
        XCTAssert(UIImage().toMultipartValue() == Payload.Multipart.ContentType.imagePNG.null)
    }
    
    func testNonEmptyImage() {
        let image: UIImage = UIImage(color: .red)
        let expectedData: Data = image.pngData()!
        XCTAssert(image.toMultipartValue() == (expectedData, .imagePNG))
    }
}
