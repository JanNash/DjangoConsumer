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

import Foundation
import Alamofire


// MARK: // Public
public protocol SessionManagerType: class {
    func request(with cfg: RequestConfiguration) -> DataRequest
    func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling)
}


// MARK: Convenience Default Implementation
public extension SessionManagerType {
    func fireJSONRequest(with cfg: RequestConfiguration, responseHandling: JSONResponseHandling) {
        DefaultImplementations._SessionManagerType_.fireJSONRequest(via: self, with: cfg, responseHandling: responseHandling)
    }
}


// MARK: - DefaultImplementations._SessionManagerType_
public extension DefaultImplementations._SessionManagerType_ {
    static func fireJSONRequest(via sessionManager: SessionManagerType, with cfg: RequestConfiguration, responseHandling: JSONResponseHandling) {
        sessionManager.handleJSONResponse(for: sessionManager.request(with: cfg), with: responseHandling)
    }
}
