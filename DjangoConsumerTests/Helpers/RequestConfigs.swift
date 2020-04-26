//
//  RequestConfigs.swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 26.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import DjangoConsumer


enum RequestConfigs {
    enum Failing {
        static let GET: RequestConfiguration = {
            .get(GETRequestConfiguration(url: URL(string: "http://example.com")!, encoding: URLEncoding.default))
        }()
        
        static func POST(_ payloadDict: Payload.Dict) -> RequestConfiguration {
            let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
            return .post(POSTRequestConfiguration(url: URL(string: "http://example.com")!, payload: payload, encoding: JSONEncoding.default))
        }
    }
    
    enum Succeeding {
        static let GET: RequestConfiguration = {
            .get(GETRequestConfiguration(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!, encoding: URLEncoding.default))
        }()
        
        static func POST(_ payloadDict: Payload.Dict) -> RequestConfiguration {
            let payload: Payload = payloadDict.toPayload(conversion: DefaultPayloadConversion(), rootObject: nil, method: .post)
            return .post(POSTRequestConfiguration(url: URL(string: "http://httpbin.org/anything")!, payload: payload, encoding: JSONEncoding.default))
        }
    }
}
