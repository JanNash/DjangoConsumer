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
    var url: URL
    var method: HTTPMethod
    var parameters: Parameters = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders = [:]
    var acceptableStatusCodes: [Int] = Array(200..<300)
    var acceptableContentTypes: [String] = ["*/*"]
}


// MARK: - SessionManagerType
public protocol SessionManagerType {
    func fireRequest(with configuration: RequestConfiguration, onSuccess: (JSON) -> Void, onFailure: (Error, JSON?) -> Void)
}
