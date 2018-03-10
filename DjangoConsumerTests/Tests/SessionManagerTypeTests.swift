//
//  SessionManagerTypeTests.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 10.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import XCTest
import Alamofire
import DjangoConsumer


// MARK: // Private
private let _fakeRequestConfig: RequestConfiguration = RequestConfiguration(url: URL(string: "http://example.com")!, method: .get)
private let _fakeResponseHandling: JSONResponseHandling = JSONResponseHandling()


// MARK: // Internal
// MARK: - AlamofireSessionManagerExtensionTests
class AlamofireSessionManagerExtensionTests: BaseTest {
    func testSessionManagerMakeDefault() {
        let sessionManager: SessionManager = .makeDefault()
        let configuration: URLSessionConfiguration = sessionManager.session.configuration
        
        guard let additionalHeaders: HTTPHeaders = configuration.httpAdditionalHeaders as? HTTPHeaders else {
            XCTFail("Expected configuration.httpAdditionalHeaders to be of type 'Alamofire.HTTPHeaders'")
            return
        }
        
        XCTAssertEqual(additionalHeaders, SessionManager.defaultHTTPHeaders)
    }
}


// MARK: - TestSessionManagerTests
class TestSessionManagerTests: BaseTest {
    func testReceivedRequestConfigCalled() {
        let sessionManager: TestSessionManager = TestSessionManager()
        
        let expectation: XCTestExpectation = self.expectation(description:
            "Expected sessionManager.receivedRequestConfig to be called"
        )
        
        sessionManager.testDelegate.receivedDataRequest = { _ in }
        
        self.waitForExpectations(timeout: 0.1)
    }
}
