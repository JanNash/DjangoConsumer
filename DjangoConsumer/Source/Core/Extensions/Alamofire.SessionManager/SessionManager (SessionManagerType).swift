//
//  SessionManager (SessionManagerType).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 10.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire


// MARK: // Public
// MARK: SessionManagerType
extension Alamofire.SessionManager: SessionManagerType {
    public func createRequest(with cfg: GETRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        self._createRequest(with: cfg, completion: completion)
    }
    
    public func createRequest(with cfg: POSTRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        self._createRequest(with: cfg, completion: completion)
    }
    
    public func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling) {
        request.responseSwiftyJSON(completionHandler: responseHandling.handleResponse)
    }
}


// MARK: // Private
private extension Alamofire.SessionManager {
    func _request(with cfg: GETRequestConfiguration) -> DataRequest {
        return self
            .request(cfg.url, method: .get, parameters: [:] /*cfg.parameters*/, encoding: cfg.encoding, headers: cfg.headers)
            .validate(statusCode: cfg.acceptableStatusCodes)
            .validate(contentType: cfg.acceptableContentTypes)
    }
    
    func _request(with cfg: POSTRequestConfiguration) -> DataRequest {
        return self
            .request(cfg.url, method: .post, parameters: [:] /*cfg.parameters*/, encoding: cfg.encoding, headers: cfg.headers)
            .validate(statusCode: cfg.acceptableStatusCodes)
            .validate(contentType: cfg.acceptableContentTypes)
    }
}
