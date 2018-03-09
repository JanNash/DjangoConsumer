//
//  TestSessionManager.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 07.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
public class TestSessionManager {
    public init() {}
    public var handleRequest: ((RequestConfiguration, ResponseHandling) -> Void)?
}

// MARK: SessionManagerType
extension TestSessionManager: SessionManagerType {
    public func fireJSONRequest(cfg: RequestConfiguration, responseHandling: ResponseHandling) {
        self.handleRequest?(cfg, responseHandling)
    }
}
