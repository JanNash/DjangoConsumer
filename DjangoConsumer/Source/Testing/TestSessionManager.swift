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
import Alamofire


// MARK: // Public
// MARK: - TestSessionDelegate
public class TestSessionDelegate: SessionDelegate {
    // Public Variables
    public var receivedRequest: ((Request) -> Void)?
    
    // Subscript Override
    override public subscript(task: URLSessionTask) -> Request? {
        get { return nil }
        set { if let newValue: Request = newValue { self.receivedRequest?(newValue) } }
    }
}


// MARK: - TestSessionManager
public class TestSessionManager {
    // Public Init
    public init() {}
    
    // Public Constants
    public let testDelegate: TestSessionDelegate = TestSessionDelegate()
    
    // Private Constants
    private lazy var _AF_sessionManager: SessionManager = .makeDefault(delegate: self.testDelegate, startsRequestsImmediately: false)
}


// MARK: SessionManagerType
extension TestSessionManager: SessionManagerType {
    public func request(with cfg: RequestConfiguration) -> DataRequest {
        return self._AF_sessionManager.request(with: cfg)
    }
}
