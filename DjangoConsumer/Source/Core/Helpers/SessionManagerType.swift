//
//  SessionManagerType.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
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
    
    var url: URL
    var method: HTTPMethod
    var parameters: Parameters
    var encoding: ParameterEncoding
    var headers: HTTPHeaders
    var acceptableStatusCodes: [Int]
    var acceptableContentTypes: [String]
}


// MARK: - ResponseHandling
public struct ResponseHandling {
    var onSuccess: (JSON) -> Void
    var onFailure: (Error) -> Void
}


// MARK: - SessionManagerType
public protocol SessionManagerType {
    func fireJSONRequest(cfg: RequestConfiguration, responseHandling: ResponseHandling)
}


// MARK: - Alamofire SessionManager: SessionManagerType
extension Alamofire.SessionManager: SessionManagerType {
    public func fireJSONRequest(cfg: RequestConfiguration, responseHandling: ResponseHandling) {
        self.request(cfg.url, method: cfg.method, parameters: cfg.parameters, encoding: cfg.encoding, headers: cfg.headers)
            .validate(statusCode: cfg.acceptableStatusCodes)
            .validate(contentType: cfg.acceptableContentTypes)
            .responseSwiftyJSON {
                switch $0.result {
                case let .success(result):
                    responseHandling.onSuccess(result)
                case let .failure(error):
                    responseHandling.onFailure(error)
                }
            }
    }
}
