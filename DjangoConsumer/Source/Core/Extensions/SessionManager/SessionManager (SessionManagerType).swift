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

import Foundation
import Alamofire


// MARK: // Public
// MARK: SessionManagerType
extension Alamofire.SessionManager: SessionManagerType {
    public func request(with cfg: RequestConfiguration) -> DataRequest {
        return self
            .request(cfg.url, method: cfg.method, parameters: cfg.parameters, encoding: cfg.encoding, headers: cfg.headers)
            .validate(statusCode: cfg.acceptableStatusCodes)
            .validate(contentType: cfg.acceptableContentTypes)
    }
}
