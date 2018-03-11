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
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - RequestConfiguration
public struct RequestConfiguration {
    public init(url: URL, method: HTTPMethod, parameters: Parameters = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:], acceptableStatusCodes: [Int] = Array(200..<300), acceptableContentTypes: [String] = ["*/*"]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.acceptableStatusCodes = acceptableStatusCodes
        self.acceptableContentTypes = acceptableContentTypes
    }
    
    public var url: URL
    public var method: HTTPMethod
    public var parameters: Parameters
    public var encoding: ParameterEncoding
    public var headers: HTTPHeaders
    public var acceptableStatusCodes: [Int]
    public var acceptableContentTypes: [String]
}


// MARK: - JSONResponseHandling
public struct JSONResponseHandling {
    // Inits
    public init() {}
    public init(onSuccess: @escaping (JSON) -> Void, onFailure: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    // Public Variables
    public var onSuccess: (JSON) -> Void = { _ in }
    public var onFailure: (Error) -> Void = { _ in }
    
    // Handle Response
    func handleResponse(_ response: DataResponse<JSON>) {
        switch response.result {
        case let .success(result):
            self.onSuccess(result)
        case let .failure(error):
            self.onFailure(error)
        }
    }
}


// MARK: - SessionManagerType
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
