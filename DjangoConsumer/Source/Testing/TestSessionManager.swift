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

import Foundation
import Alamofire


// MARK: // Public
// MARK: Interface
public extension TestSessionManager {
    public func resetHandlers() {
        self._resetHandlers()
    }
}


// MARK: Class Declaration
public class TestSessionManager {
    // Init
    public init() {}
    
    // Public Variables
    public var receivedRequestConfig: ((RequestConfiguration) -> ())?
    public var createdRequest: ((DataRequest) -> ())?
    public var mockResponse: ((DataRequest, ResponseHandling) -> ())?
    
    // Private Constants
    private let _AF_SessionManager: SessionManager = {
        let sessionManager: SessionManager = .makeDefault()
        sessionManager.startRequestsImmediately = false
        return sessionManager
    }()
}


// MARK: SessionManagerType
extension TestSessionManager: SessionManagerType {
    public func createRequest(from cfg: RequestConfiguration) -> DataRequest {
        return self._createRequest(from: cfg)
    }
    
    public func fireRequest(_ request: DataRequest, responseHandling: ResponseHandling) {
        self.mockResponse?(request, responseHandling)
    }
}


// MARK: // Private
// MARK: SessionManagerType Implementation
private extension TestSessionManager/*: SessionManagerType*/ {
    func _createRequest(from cfg: RequestConfiguration) -> DataRequest {
        self.receivedRequestConfig?(cfg)
        let request: DataRequest = self._AF_SessionManager.createRequest(from: cfg)
        self.createdRequest?(request)
        return request
    }
}


// MARK: Reset Handlers
private extension TestSessionManager {
    func _resetHandlers() {
        self.receivedRequestConfig = nil
        self.createdRequest = nil
        self.mockResponse = nil
    }
}
