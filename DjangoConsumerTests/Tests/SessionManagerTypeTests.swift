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
import SwiftyJSON
import DjangoConsumer


// MARK: // Private
private let _failingRequestConfig: RequestConfiguration = {
    RequestConfiguration(url: URL(string: "http://example.com")!, method: .get)
}()

private let _succeedingRequestConfig: RequestConfiguration = {
    RequestConfiguration(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!, method: .get)
}()

private enum _TestError: Error { case foo }


// MARK: // Internal
// MARK: - SessionManagerTypeTests
class SessionManagerTypeTests: BaseTest {
    // Helper Class
    class _MockSessionManager: SessionManagerType {
        var requestWithCFGCalled: (() -> Void)?
        
        private var _AF_sessionManager: SessionManager = SessionManager()
        
        func request(with cfg: RequestConfiguration) -> DataRequest {
            self.requestWithCFGCalled?()
            return self._AF_sessionManager.request(with: cfg)
        }
        
        func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling) {
            responseHandling.onSuccess(JSON())
            responseHandling.onFailure(_TestError.foo)
        }
    }
    
    // Tests
    func testSessionManagerTypeDefaultImplementations1() {
        let sessionManager: _MockSessionManager = _MockSessionManager()
        
        sessionManager.requestWithCFGCalled = self.expectation(
            description: "Expected sessionManager.request(with cfg:) to be called"
        ).fulfill
        
        let onSuccessExpectation: XCTestExpectation = self.expectation(
            description: "Expected responseHandling.onSuccess() to be called"
        )
        
        let onFailureExpectation: XCTestExpectation = self.expectation(
            description: "Expected responseHandling.onFailure() to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in onSuccessExpectation.fulfill() },
            onFailure: { _ in onFailureExpectation.fulfill() }
        )
        
        DefaultImplementations._SessionManagerType_.fireJSONRequest(
            via: sessionManager,
            with: _failingRequestConfig,
            responseHandling: responseHandling
        )
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testSessionManagerTypeDefaultImplementations() {
        let sessionManager: _MockSessionManager = _MockSessionManager()
        
        sessionManager.requestWithCFGCalled = self.expectation(
            description: "Expected sessionManager.request(with cfg:) to be called"
            ).fulfill
        
        let onSuccessExpectation: XCTestExpectation = self.expectation(
            description: "Expected responseHandling.onSuccess() to be called"
        )
        
        let onFailureExpectation: XCTestExpectation = self.expectation(
            description: "Expected responseHandling.onFailure() to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in onSuccessExpectation.fulfill() },
            onFailure: { _ in onFailureExpectation.fulfill() }
        )
        
        sessionManager.fireJSONRequest(with: _failingRequestConfig, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 0.1)
    }
}


// MARK: - AlamofireSessionManagerExtensionTests
class AlamofireSessionManagerExtensionTests: BaseTest {
    func testAFSessionManagerMakeDefault() {
        let sessionManager: SessionManager = .makeDefault()
        let configuration: URLSessionConfiguration = sessionManager.session.configuration
        
        guard let additionalHeaders: HTTPHeaders = configuration.httpAdditionalHeaders as? HTTPHeaders else {
            XCTFail("Expected configuration.httpAdditionalHeaders to be of type 'Alamofire.HTTPHeaders'")
            return
        }
        
        XCTAssertEqual(additionalHeaders, SessionManager.defaultHTTPHeaders)
    }
    
    func testAFSessionManagerFireJSONRequestWithFailingRequestConfig() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { XCTFail("'onSuccess' should not be called but was called with json: \($0)") },
            onFailure: { _ in expectation.fulfill() }
        )
        
        sessionManager.fireJSONRequest(with: _failingRequestConfig, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testAFSessionManagerFireJSONRequestWithSucceedingRequestConfig() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onSuccess' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in expectation.fulfill() },
            onFailure: { XCTFail("'onFailure' should not be called but was called with error: \($0)") }
        )
        
        sessionManager.fireJSONRequest(with: _succeedingRequestConfig, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 1)
    }
}


// MARK: - TestSessionDelegateTests
class TestSessionDelegateTests: BaseTest {
    func testTestSessionDelegateSubscriptSetter() {
        let sessionDelegate: TestSessionDelegate = TestSessionDelegate()
        let sessionManager: SessionManagerType = SessionManager()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected sessionDelegate.receivedDataRequest to be called"
        )
        
        sessionDelegate.receivedDataRequest = { _ in
            expectation.fulfill()
        }
        
        let fakeTask: URLSessionTask = URLSessionTask()
        let fakeRequest: DataRequest = sessionManager.request(with: _failingRequestConfig)
        
        sessionDelegate[fakeTask] = fakeRequest
        
        self.waitForExpectations(timeout: 0.1)
    }
    
    func testTestSessionDelegateSubscriptGetter() {
        let sessionDelegate: TestSessionDelegate = TestSessionDelegate()
        let fakeTask: URLSessionTask = URLSessionTask()
        
        XCTAssertNil(sessionDelegate[fakeTask])
    }
}


// MARK: - TestSessionManagerTests
class TestSessionManagerTests: BaseTest {
    func testTestSessionManagerRequestWithConfig() {
        let sessionManager: TestSessionManager = TestSessionManager()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected sessionManager.testDelegate.receivedDataRequest to be called"
        )
        
        var receivedRequest: DataRequest?
        
        sessionManager.testDelegate.receivedDataRequest = {
            receivedRequest = $0
            expectation.fulfill()
        }
        
        let expectedRequest: DataRequest = sessionManager.request(with: _failingRequestConfig)
        
        self.waitForExpectations(timeout: 01, handler: { _ in
            XCTAssert(receivedRequest === expectedRequest)
        })
    }
    
    func testTestSessionManagerHandleJSONResponse() {
        let sessionManager: TestSessionManager = TestSessionManager()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected sessionManager.testDelegate.mockJSONResponse to be called"
        )
        
        let expectedRequest: DataRequest = sessionManager.request(with: _failingRequestConfig)
        
        // This funny pattern is used because functions can't be tested for equality
        // and JSONResponseHandling is a struct, so it's quite impossible to make
        // it conform to Equatable, which is fine, because I deem it also quite unnecessary.
        var onSuccessCalled: Bool = false
        var onFailureCalled: Bool = false
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { _ in onSuccessCalled = true },
            onFailure: { _ in onFailureCalled = true }
        )
        
        sessionManager.testDelegate.mockJSONResponse = { req, resp in
            XCTAssert(req === expectedRequest)
            
            resp.onSuccess(JSON())
            XCTAssertTrue(onSuccessCalled)
            
            resp.onFailure(_TestError.foo)
            XCTAssertTrue(onFailureCalled)
            
            expectation.fulfill()
        }
        
        sessionManager.handleJSONResponse(for: expectedRequest, with: responseHandling)
        
        self.waitForExpectations(timeout: 0.1)
    }
}
