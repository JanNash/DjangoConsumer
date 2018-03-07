//
//  TestSessionManager.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
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
