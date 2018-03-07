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
    public var onSuccess: (JSON) -> Void
    public var onFailure: (Error) -> Void
}


// MARK: - SessionManagerType
public protocol SessionManagerType {
    func fireJSONRequest(cfg: RequestConfiguration, responseHandling: ResponseHandling)
}


// MARK: - Alamofire SessionManager Extensions
// MARK: SessionManagerType
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


// MARK: withDefaultConfiguration
public extension Alamofire.SessionManager {
    public static func withDefaultConfiguration() -> Alamofire.SessionManager {
        // This is copied from the SessionManager implementation
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }
}
