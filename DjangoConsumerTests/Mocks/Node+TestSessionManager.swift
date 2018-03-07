//
//  Node+TestSessionManager.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import DjangoConsumer


// MARK: // Internal
// MARK: Testing Convenience Interface
extension Node {
    var testSessionManager: TestSessionManager {
        return self.sessionManager as! TestSessionManager
    }
}
