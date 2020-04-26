//
//  SessionManager (SessionManagerType) Tests.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 25.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
// Alamofire must be imported as testable so we have access to the validations list.
// Then again, there seems to be no good way to properly test the validations yet 🤨
@testable import Alamofire
@testable import DjangoConsumer


// MARK: -
// MARK: Smoke Tests
class SessionManager_SessionManagerType_SmokeTests: BaseTest {
    func testFireJSONRequestWithFailingGETRequestConfig() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { XCTFail("'onSuccess' should not be called but was called with json: \($0)") },
            onFailure: { _ in expectation.fulfill() }
        )
        
        sessionManager.fireRequest(with: RequestConfigs.Failing.GET, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 100)
    }
    
    func testAFSessionManagerFireJSONRequestWithSucceedingGETRequestConfig() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onSuccess' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in expectation.fulfill() },
            onFailure: { XCTFail("'onFailure' should not be called but was called with error: \($0)") }
        )
        
        sessionManager.fireRequest(with: RequestConfigs.Succeeding.GET, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 100)
    }
    
    func testAFSessionManagerFireJSONRequestWithFailingPOSTRequestConfigWithPureJSONPayload() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()

        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )

        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { XCTFail("'onSuccess' should not be called but was called with json: \($0)") },
            onFailure: { _ in expectation.fulfill() }
        )

        sessionManager.fireRequest(with: RequestConfigs.Failing.POST(["foo": "bar"]), responseHandling: responseHandling)

        self.waitForExpectations(timeout: 100)
    }

    func testAFSessionManagerFireJSONRequestWithSucceedingPOSTRequestConfigWithPureJSONPayload() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()

        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onSuccess' to be called"
        )

        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in expectation.fulfill() },
            onFailure: { XCTFail("'onFailure' should not be called but was called with error: \($0)") }
        )

        sessionManager.fireRequest(with: RequestConfigs.Succeeding.POST(["foo": "bar"]), responseHandling: responseHandling)

        self.waitForExpectations(timeout: 100)
    }
    
    func testAFSessionManagerFireJSONRequestWithFailingPOSTRequestConfigWithMixedMultipartAndJSONPayload() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { XCTFail("'onSuccess' should not be called but was called with json: \($0)") },
            onFailure: { _ in expectation.fulfill() }
        )
        
        let requestConfiguration: RequestConfiguration = RequestConfigs.Failing.POST([
            "foo": "bar",
            "image": UIImage()
        ])
        
        sessionManager.fireRequest(with: requestConfiguration, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 100)
    }
    
    func testAFSessionManagerFireJSONRequestWithSucceedingPOSTRequestConfigWithMixedMultipartAndJSONPayload() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onSuccess' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in expectation.fulfill() },
            onFailure: { XCTFail("'onFailure' should not be called but was called with error: \($0)") }
        )
        
        let barbar: Payload.Dict = [
            "nickname": "barbar",
            "images": [
                UIImage(color: .clear),
                UIImage(color: .red),
                UIImage(color: .yellow),
                UIImage(color: .green),
                UIImage(color: .blue),
                UIImage(color: .black),
            ],
            "other_things": [
                "apple",
                "banana",
                "boat",
                "elephant"
            ],
            "age": "about as old as foofoo",
            "friend": "no, I don't want to overflow the stack yet...",
        ]
        
        let foofoo: Payload.Dict = [
            "nickname": "foofoo",
            "images": [
                UIImage(color: .clear),
                UIImage(color: .red),
                UIImage(color: .yellow),
                UIImage(color: .green),
                UIImage(color: .blue),
                UIImage(color: .black),
            ],
            "other_things": [
                "apple",
                "banana",
                "boat",
                "elephant"
            ],
            "age": "quite old",
            "friend": barbar,
        ]
        
        let requestConfiguration: RequestConfiguration = RequestConfigs.Succeeding.POST([
            "username": "foo",
            "email": "foo@example.com",
            "created_at": Date(),
            "profile": foofoo
        ])
        
        sessionManager.fireRequest(with: requestConfiguration, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 100)
    }
}


// MARK: Detailed Tests
class SessionManager_SessionManagerType_Tests: BaseTest {
    func testCreateRequestURLEncodedVerbose() {
        let sessionManager: Alamofire.SessionManager = .makeDefault()
        
        let expectedScheme: String = "http"
        let expectedHost: String = "example.com"
        
        let expectedURL: URL = URL(string: "\(expectedScheme)://\(expectedHost)")!
        let expectedEncoding: ParameterEncoding = URLEncoding.default
        let expectedParameters: Payload.JSON.Dict = ["foo": "bar", "answer": 42]
        let expectedHeaders: HTTPHeaders = ["baz": "zoing", "13": "19"]
        let expectedStatusCodes: [Int] = Array(0...100)
        let expectedContentTypes: [String] = ["foo/bar"]
        
        let cfg: GETRequestConfiguration = GETRequestConfiguration(
            url: expectedURL,
            parameters: expectedParameters,
            encoding: expectedEncoding,
            headers: expectedHeaders,
            acceptableStatusCodes: expectedStatusCodes,
            acceptableContentTypes: expectedContentTypes
        )
        
        sessionManager.createRequest(with: .get(cfg), completion: {
            switch $0 {
            case .created(let request):
                guard let urlRequest: URLRequest = request.request else {
                    XCTFail("No urlRequest was created")
                    return
                }
                
                guard let requestURL: URL = urlRequest.url else {
                    XCTFail("URLRequest has no url")
                    return
                }
                
                let components: URLComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)!
                XCTAssertEqual(components.scheme, expectedScheme)
                XCTAssertEqual(components.host, expectedHost)
                
                guard let queryItems: [URLQueryItem] = components.queryItems else {
                    XCTFail("URLRequest has no queryItems")
                    return
                }
                
                XCTAssert(queryItems.count == expectedParameters.count)
                for queryItem in queryItems {
                    let key: String = queryItem.name
                    guard let expectedValue: Payload.JSON.Dict.Value = expectedParameters[key] else {
                        XCTFail("Unexpected key '\(key)' in queryItems")
                        return
                    }
                    XCTAssertEqual("\(expectedValue)", queryItem.value)
                }
                
                guard let headers: HTTPHeaders = urlRequest.allHTTPHeaderFields else {
                    XCTFail("URLRequest has no headers")
                    return
                }
                
                XCTAssert(headers.count == expectedHeaders.count)
                for header in headers {
                    let key: String = header.key
                    guard let expectedHeaderValue: String = expectedHeaders[key] else {
                        XCTFail("Unexpected key '\(key)' in headers")
                        return
                    }
                    XCTAssertEqual(expectedHeaderValue, header.value)
                }
                
                // ???: How can the validations be tested better than that
                XCTAssert(request.validations.count == 2)
            case .failed(let error):
                // TODO: Test the error case
                print(error)
            }
        })
    }
}
