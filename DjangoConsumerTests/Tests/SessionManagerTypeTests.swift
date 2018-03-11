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
private let _badRequestConfig: RequestConfiguration = {
    RequestConfiguration(url: URL(string: "http://example.com")!, method: .get)
}()

private let _goodRequestConfig: RequestConfiguration = {
    RequestConfiguration(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!, method: .get)
}()


// MARK: // Internal
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
    
    func testAFSessionManagerFireJSONRequest() {
        let sessionManager: SessionManager = .makeDefault()
        
        let expectation: XCTestExpectation = self.expectation(
            description: "Expected 'onFailure' to be called"
        )
        
        func onSuccess(_ json: JSON) {
            XCTFail("'onSuccess' should not be called")
        }
        
        func onFailure(_ error: Error) {
            expectation.fulfill()
        }
        
        let responseHandling: JSONResponseHandling = JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        
        sessionManager.fireJSONRequest(with: _badRequestConfig, responseHandling: responseHandling)
        
        self.waitForExpectations(timeout: 1)
    }
}


// MARK: - TestSessionManagerTests
class TestSessionManagerTests: BaseTest {
    
}
