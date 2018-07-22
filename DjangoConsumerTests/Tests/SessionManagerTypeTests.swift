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
private enum _RequestConfigs {
    enum Failing {
        static let GET: RequestConfiguration = {
            .get(GETRequestConfiguration(url: URL(string: "http://example.com")!, encoding: URLEncoding.default))
        }()
        
        static func POST(_ payloadDict: Payload.Dict) -> RequestConfiguration {
            let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
            return .post(POSTRequestConfiguration(url: URL(string: "http://example.com")!, payload: payload, encoding: JSONEncoding.default))
        }
    }
    
    enum Succeeding {
        static let GET: RequestConfiguration = {
            .get(GETRequestConfiguration(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!, encoding: URLEncoding.default))
        }()
        
        static func POST(_ payloadDict: Payload.Dict) -> RequestConfiguration {
            let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
            return .post(POSTRequestConfiguration(url: URL(string: "http://httpbin.org/anything")!, payload: payload, encoding: JSONEncoding.default))
        }
    }
}

private enum _TestError: Error { case foo }


// MARK: // Internal
// MARK: - SessionManagerTypeTests
class SessionManagerTypeTests: BaseTest {
    // Helper Class
    class _MockSessionManager: SessionManagerType {
        var requestWithCFGCalled: (() -> Void)?
        
        private var _AF_sessionManager: SessionManager = SessionManager()
        
        func createRequest(with cfg: RequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
            self.requestWithCFGCalled?()
            self._AF_sessionManager.createRequest(with: cfg, completion: completion)
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
        
        DefaultImplementations.SessionManagerType.fireRequest(
            via: sessionManager,
            with: _RequestConfigs.Failing.GET,
            responseHandling: responseHandling
        )
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testSessionManagerTypeDefaultImplementations2() {
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
        
        sessionManager.fireRequest(with: _RequestConfigs.Failing.GET, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 10)
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
    
    func testAFSessionManagerFireJSONRequestWithFailingGETRequestConfig() {
        let sessionManager: SessionManagerType = SessionManager.makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(
            onSuccess: { XCTFail("'onSuccess' should not be called but was called with json: \($0)") },
            onFailure: { _ in expectation.fulfill() }
        )
        
        sessionManager.fireRequest(with: _RequestConfigs.Failing.GET, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 10)
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
        
        sessionManager.fireRequest(with: _RequestConfigs.Succeeding.GET, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 10)
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

        sessionManager.fireRequest(with: _RequestConfigs.Failing.POST(["foo": "bar"]), responseHandling: responseHandling)

        self.waitForExpectations(timeout: 10)
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

        sessionManager.fireRequest(with: _RequestConfigs.Succeeding.POST(["foo": "bar"]), responseHandling: responseHandling)

        self.waitForExpectations(timeout: 10)
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
        
        let requestConfiguration: RequestConfiguration = _RequestConfigs.Failing.POST([
            "foo": "bar",
            "image": UIImage()
        ])
        
        sessionManager.fireRequest(with: requestConfiguration, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 10)
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
            "image": UIImage(color: .clear),
            "age": "about as old as foofoo",
            "friend": "no, I don't want to overflow the stack yet..."
        ]
        
        let foofoo: Payload.Dict = [
            "nickname": "foofoo",
            "image": UIImage(color: .clear),
            "age": "quite old",
            "friend": barbar
        ]
        
        let requestConfiguration: RequestConfiguration = _RequestConfigs.Succeeding.POST([
            "username": "foo",
            "email": "foo@example.com",
            "created_at": Date(),
            "profile": foofoo
        ])
        
        sessionManager.fireRequest(with: requestConfiguration, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 10)
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
        sessionManager.createRequest(with: _RequestConfigs.Failing.GET) {
            switch $0 {
            case .failed(let error):
                XCTFail("Request creation failed with error \(error)")
            case .created(let request):
                sessionDelegate[fakeTask] = request
            }
            
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testTestSessionDelegateSubscriptGetter() {
        let sessionManager: SessionManagerType = SessionManager()
        let sessionDelegate: TestSessionDelegate = TestSessionDelegate()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected sessionManager.createRequest completion to be called"
        )
        
        let fakeTask: URLSessionTask = URLSessionTask()
        sessionManager.createRequest(with: _RequestConfigs.Failing.GET) {
            switch $0 {
            case .failed(let error):
                XCTFail("Request creation failed with error \(error)")
            case .created(let request):
                sessionDelegate[fakeTask] = request
                XCTAssertNil(sessionDelegate[fakeTask])
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
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
        
        sessionManager.createRequest(with: _RequestConfigs.Failing.GET) {
            switch $0 {
            case .failed(let error):
                XCTFail("Request creation failed with error \(error)")
            case .created(let request):
                XCTAssert(request === receivedRequest)
            }
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testTestSessionManagerHandleJSONResponse() {
        let sessionManager: TestSessionManager = TestSessionManager()

        let expectation: XCTestExpectation = self.expectation(
            description: "Expected sessionManager.testDelegate.mockJSONResponse to be called"
        )

        sessionManager.createRequest(with: _RequestConfigs.Failing.GET) {
            switch $0 {
            case .failed(let error):
                XCTFail("Request creation failed with error \(error)")
            case .created(let request):
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
                    XCTAssert(req === request)

                    resp.onSuccess(JSON())
                    XCTAssertTrue(onSuccessCalled)

                    resp.onFailure(_TestError.foo)
                    XCTAssertTrue(onFailureCalled)

                    expectation.fulfill()
                }

                sessionManager.handleJSONResponse(for: request, with: responseHandling)
            }
        }
            
        self.waitForExpectations(timeout: 10)
    }
}
