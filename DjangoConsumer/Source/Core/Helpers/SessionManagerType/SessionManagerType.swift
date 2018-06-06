//
//  SessionManagerType.swift
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
// MARK: -
public enum RequestCreationResult {
    case created(DataRequest)
    case failed(Error)
}


// MARK: -
public protocol SessionManagerType: class {
    func createRequest(with cfg: GETRequestConfiguration, completion: (RequestCreationResult) -> Void)
    func createRequest(with cfg: POSTRequestConfiguration, completion: (RequestCreationResult) -> Void)
    func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling)
}


// MARK: Convenience Default Implementation
public extension SessionManagerType {
    func fireRequest(with cfg: GETRequestConfiguration, responseHandling: JSONResponseHandling) {
        DefaultImplementations.SessionManagerType.fireRequest(via: self, with: cfg, responseHandling: responseHandling)
    }
    
    func fireRequest(with cfg: POSTRequestConfiguration, responseHandling: JSONResponseHandling) {
        DefaultImplementations.SessionManagerType.fireRequest(via: self, with: cfg, responseHandling: responseHandling)
    }
    
    func handle(requestCreationResult: RequestCreationResult, responseHandling: JSONResponseHandling) {
        DefaultImplementations.SessionManagerType.handle(requestCreationResult: requestCreationResult, of: self, responseHandling: responseHandling)
    }
}


// MARK: - DefaultImplementations.SessionManagerType
public extension DefaultImplementations.SessionManagerType {
    static func fireRequest(via sessionManager: SessionManagerType, with cfg: GETRequestConfiguration, responseHandling: JSONResponseHandling) {
        sessionManager.createRequest(with: cfg) {
            sessionManager.handle(requestCreationResult: $0, responseHandling: responseHandling)
        }
    }
    
    static func fireRequest(via sessionManager: SessionManagerType, with cfg: POSTRequestConfiguration, responseHandling: JSONResponseHandling) {
        sessionManager.createRequest(with: cfg) {
            sessionManager.handle(requestCreationResult: $0, responseHandling: responseHandling)
        }
    }
    
    static func handle(requestCreationResult: RequestCreationResult, of sessionManager: SessionManagerType, responseHandling: JSONResponseHandling) {
        switch requestCreationResult {
        case .created(let request):
            sessionManager.handleJSONResponse(for: request, with: responseHandling)
        case .failed(let error):
            responseHandling.onFailure(error)
        }
    }
}
