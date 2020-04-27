//
//  RequestConfiguration Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 08.04.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import DjangoConsumer


// MARK: // Internal
class RequestConfigurationTests: BaseTest {
    func testRequestConfigurationInitOmittingOptionalParameters() {
        let expectedURL: URL = URL(string: "http://example.com")!
        let expectedEncoding: ParameterEncoding = URLEncoding.default
        
        let cfg: GETRequestConfiguration = GETRequestConfiguration(
            url: expectedURL,
            encoding: expectedEncoding
        )
        
        let expectedParameters: Payload.JSON.Dict = [:]
        let expectedHeaders: HTTPHeaders = [:]
        let expectedAcceptableStatusCodes: [Int] = Array(200..<300)
        let expectedAcceptableContentTypes: [String] = ["*/*"]
        
        XCTAssertEqual(cfg.url, expectedURL)
        XCTAssert(cfg.encoding is URLEncoding)
        XCTAssertEqual(cfg.parameters, expectedParameters)
        XCTAssertEqual(cfg.headers, expectedHeaders)
        XCTAssertEqual(cfg.acceptableStatusCodes, expectedAcceptableStatusCodes)
        XCTAssertEqual(cfg.acceptableContentTypes, expectedAcceptableContentTypes)
    }
    
    func testRequestConfigurationInitWithAllParameters() {
        let expectedURL: URL = URL(string: "http://example.com")!
        let expectedEncoding: ParameterEncoding = JSONEncoding.default
        let expectedPayload: Payload = Payload.Dict(["foo": "bar"]).toPayload(
            conversion: DefaultPayloadConversion(), rootObject: nil, method: .post
        )
        let expectedHeaders: HTTPHeaders = ["Alice": "Bob"]
        let expectedAcceptableStatusCodes: [Int] = Array(200..<300)
        let expectedAcceptableContentTypes: [String] = ["bla/blu"]
        
        let cfg: POSTRequestConfiguration = POSTRequestConfiguration(
            url: expectedURL,
            payload: expectedPayload,
            encoding: expectedEncoding,
            headers: expectedHeaders,
            acceptableStatusCodes: expectedAcceptableStatusCodes,
            acceptableContentTypes: expectedAcceptableContentTypes
        )
        
        XCTAssertEqual(cfg.url, expectedURL)
        XCTAssert(cfg.encoding is JSONEncoding)
        XCTAssertEqual(cfg.payload, expectedPayload)
        XCTAssertEqual(cfg.headers, expectedHeaders)
        XCTAssertEqual(cfg.acceptableStatusCodes, expectedAcceptableStatusCodes)
        XCTAssertEqual(cfg.acceptableContentTypes, expectedAcceptableContentTypes)
    }
}
