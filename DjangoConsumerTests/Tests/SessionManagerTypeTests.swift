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


// MARK: // Internal
class TestSessionManagerTests: XCTestCase {
    private let _fakeRequestConfig: RequestConfiguration = RequestConfiguration(url: URL(string: "http://example.com")!, method: .get)
    private let _fakeResponseHandling: ResponseHandling = ResponseHandling()
    
    func testReceivedRequestConfigCalled() {
        let sessionManager: TestSessionManager = TestSessionManager()
        
        let expectation: XCTestExpectation = self.expectation(description:
            "Expected sessionManager.receivedRequestConfig to be called"
        )
        
        sessionManager.receivedRequestConfig = { _ in
            expectation.fulfill()
        }
        
        sessionManager.fireJSONRequest(cfg: self._fakeRequestConfig, responseHandling: self._fakeResponseHandling)
        
        self.waitForExpectations(timeout: 0.1)
    }
}
