//
//  RequestPayload.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 02.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire


// MARK: // Public
// MARK: -
public enum RequestPayload {
    case jsonDict(JSONDict)
    case multipart(MultipartDict)
    
    public enum Unwrapped {
        case json(Parameters)
        case multipart(MultipartPayload)
    }
}


// MARK: -
public protocol RequestPayloadConvertible {
    func toPayload(for method: ResourceHTTPMethod) -> RequestPayload
}
