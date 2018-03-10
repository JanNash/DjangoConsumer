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


// MARK: - ResponseHandling
public struct ResponseHandling {
    // Inits
    public init() {}
    public init(onSuccess: @escaping (JSON) -> Void, onFailure: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }
    
    // Public Variables
    public var onSuccess: (JSON) -> Void = { _ in }
    public var onFailure: (Error) -> Void = { _ in }
}


// MARK: - SessionManagerType
public protocol SessionManagerType {
    func createRequest(from cfg: RequestConfiguration) -> DataRequest
    func fireRequest(_ request: DataRequest, responseHandling: ResponseHandling)
}


// MARK: Default Implementations
public extension SessionManagerType {
    public func fireJSONRequest(cfg: RequestConfiguration, responseHandling: ResponseHandling) {
        self.fireRequest(self.createRequest(from: cfg), responseHandling: responseHandling)
    }
}


// MARK: - Alamofire.SessionManager Extensions
// MARK: SessionManagerType
extension Alamofire.SessionManager: SessionManagerType {
    public func createRequest(from cfg: RequestConfiguration) -> DataRequest {
        return self
            .request(cfg.url, method: cfg.method, parameters: cfg.parameters, encoding: cfg.encoding, headers: cfg.headers)
            .validate(statusCode: cfg.acceptableStatusCodes)
            .validate(contentType: cfg.acceptableContentTypes)
    }
    
    public func fireRequest(_ request: DataRequest, responseHandling: ResponseHandling) {
        request.responseSwiftyJSON {
            switch $0.result {
            case let .success(result):
                responseHandling.onSuccess(result)
            case let .failure(error):
                responseHandling.onFailure(error)
            }
        }
    }
}
