//
//  Node+TestSessionManager.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash (privat) on 07.03.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation


// MARK: // Public
// MARK: Testing Convenience Interface
public extension Node {
    var testSessionManager: TestSessionManager {
        return self.sessionManager as! TestSessionManager
    }
}
