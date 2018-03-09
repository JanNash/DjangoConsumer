//
//  Node+TestSessionManager.swift
//  DjangoConsumerTests
//
//  Created by Jan Nash on 07.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: Testing Convenience Interface
public extension Node {
    var testSessionManager: TestSessionManager {
        return self.sessionManager as! TestSessionManager
    }
}
