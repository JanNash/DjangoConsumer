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
    public func createRequest(with cfg: RequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        self._createRequest(with: cfg, completion: completion)
    }
    
    public func handleJSONResponse(for request: DataRequest, with responseHandling: JSONResponseHandling) {
        request.responseSwiftyJSON(completionHandler: responseHandling.handleResponse)
    }
}


// MARK: // Private
private extension Alamofire.SessionManager {
    func _createRequest(with cfg: RequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        switch cfg {
        case .get(let config):  self._createRequest(with: config, completion: completion)
        case .post(let config): self._createRequest(with: config, completion: completion)
        }
    }
    
    func _createRequest(with cfg: GETRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        completion(.created(
            self.request(cfg.url, method: .get, parameters: cfg.parameters.unwrap(), encoding: cfg.encoding, headers: cfg.headers)
                .validate(statusCode: cfg.acceptableStatusCodes)
                .validate(contentType: cfg.acceptableContentTypes)
        ))
    }
    
    func _createRequest(with cfg: POSTRequestConfiguration, completion: @escaping (RequestCreationResult) -> Void) {
        switch cfg.payload {
        
        case .json(let parameters):
            completion(.created(
                self.request(cfg.url, method: .post, parameters: parameters, encoding: cfg.encoding, headers: cfg.headers)
                    .validate(statusCode: cfg.acceptableStatusCodes)
                    .validate(contentType: cfg.acceptableContentTypes)
                ))
        
        case .multipart(let multipartDictionary):
            self.upload(multipartFormData: { multipartFormData in
                // ???: Is it possible to encode a whole JSON object (i.e. dictionary) into one body part?
                // ???: We're passing in application/json as mimeType for single jsonValues, this should be correct, is it though?
                multipartDictionary.forEach({
                    multipartFormData.append($0.value.0, withName: $0.key, mimeType: $0.value.1.rawValue)
                })
            }, to: cfg.url, method: .post, headers: cfg.headers, encodingCompletion: {
                switch $0 {
                case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                    completion(.created(request))
                case .failure(let error):
                    completion(.failed(error))
                }
            })
        }
    }
}
