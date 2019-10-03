//
//  SessionManager (makeDefault).swift
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
public extension Alamofire.SessionManager {
    static func makeDefault(delegate: SessionDelegate = SessionDelegate(), startsRequestsImmediately: Bool = true) -> SessionManager {
        // This is partially and kindly copied from the SessionManager.default implementation in Alamofire
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionManager: SessionManager = SessionManager(configuration: configuration, delegate: delegate)
        sessionManager.startRequestsImmediately = startsRequestsImmediately
        return sessionManager
    }
}
