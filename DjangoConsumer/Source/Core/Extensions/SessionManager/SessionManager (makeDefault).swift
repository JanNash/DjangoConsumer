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

import Foundation
import Alamofire


// MARK: // Public
public extension Alamofire.SessionManager {
    public static func makeDefault() -> Alamofire.SessionManager {
        // This is copied from the SessionManager implementation
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }
}
