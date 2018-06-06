//
//  TestSessionManager.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 07.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire


// MARK: // Public
// MARK: - TestSessionDelegate
public class TestSessionDelegate: SessionDelegate {
    // Public Variables
    public var receivedDataRequest: ((DataRequest) -> Void)?
    public var mockJSONResponse: ((DataRequest, JSONResponseHandling) -> Void)?
    
    // Subscript Override
    override public subscript(task: URLSessionTask) -> Request? {
        get { return nil }
        set(r) { ifT(his: r, isA: DataRequest.self, then: self.receivedDataRequest) }
    }
}


// MARK: - TestSessionManager
public class TestSessionManager {
    // Public Init
    public init() {}
    
    // Public Constants
    public let testDelegate: TestSessionDelegate = TestSessionDelegate()
    
    // Private Constants
    private lazy var _AF_sessionManager: SessionManager = .makeDefault(delegate: self.testDelegate, startsRequestsImmediately: false)
}


// MARK: SessionManagerType
extension TestSessionManager: SessionManagerType {
    public func createRequest(with cfg: POSTRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        self._AF_sessionManager.createRequest(with: cfg, completion: completion)
    }
    
    public func createRequest(with cfg: GETRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        self._AF_sessionManager.createRequest(with: cfg, completion: completion)
    }
    
    public func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling) {
        self.testDelegate.mockJSONResponse?(request, responseHandling)
    }
}
