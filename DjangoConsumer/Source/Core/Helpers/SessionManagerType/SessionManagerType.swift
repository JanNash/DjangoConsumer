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
public protocol SessionManagerType: class {
    func createRequest(with cfg: GETRequestConfiguration) -> DataRequest
    func createRequest(with cfg: POSTRequestConfiguration) -> DataRequest
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
}


// MARK: - DefaultImplementations.SessionManagerType
public extension DefaultImplementations.SessionManagerType {
    static func fireRequest(via sessionManager: SessionManagerType, with cfg: GETRequestConfiguration, responseHandling: JSONResponseHandling) {
        sessionManager.handleJSONResponse(for: sessionManager.createRequest(with: cfg), with: responseHandling)
    }
    
    static func fireRequest(via sessionManager: SessionManagerType, with cfg: POSTRequestConfiguration, responseHandling: JSONResponseHandling) {
        sessionManager.handleJSONResponse(for: sessionManager.createRequest(with: cfg), with: responseHandling)
    }
}
