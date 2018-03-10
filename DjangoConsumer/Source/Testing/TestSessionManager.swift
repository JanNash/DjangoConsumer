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
    // Fileprivate Variables
    fileprivate var _receivedRequest: ((Request) -> Void)?
    
    // Subscript Override
    override public subscript(task: URLSessionTask) -> Request? {
        get { return nil }
        set { if let newValue: Request = newValue { self._receivedRequest?(newValue) } }
    }
}


// MARK: - TestSessionManager
public class TestSessionManager {
    // Public Init
    public init() {}
    
    // Public Variables
    public var requestHandedToDelegate: ((Request) -> Void)? {
        get { return self._testDelegate._receivedRequest }
        set { self._testDelegate._receivedRequest = newValue }
    }
    
    // Private Constants
    private let _testDelegate: TestSessionDelegate = TestSessionDelegate()
    private lazy var _AF_sessionManager: SessionManager = .makeDefault(delegate: self._testDelegate, startsRequestsImmediately: false)
}


// MARK: SessionManagerType
extension TestSessionManager: SessionManagerType {
    public func request(with cfg: RequestConfiguration) -> DataRequest {
        return self._AF_sessionManager.request(with: cfg)
    }
}
