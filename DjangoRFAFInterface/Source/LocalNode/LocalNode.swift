//
//  LocalNode.swift
//  DjangoRFAFInterface
//
//  Created by Jan Nash (privat) on 19.01.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Embassy
import EnvoyAmbassador


// MARK: // Public
// MARK: Overridable Interface
extension LocalNode {
    // Route Creation
    open func createListRoute<T: LocalNodeListGettable>(for objectType: T.Type) -> Route {
        return self._createListRoute(for: objectType)
    }
}


// MARK: Public Interface
extension LocalNode {
    // Typealiases
    public typealias Route = (relativeEndpoint: URL, response: WebApp)
    
    // Functions
    // Start / Stop
    public func start() {
        self._start()
    }
    
    public func stop() {
        self._stop()
    }
    
    public func restart() {
        self._restart()
    }
    
    // Adding/Removing Routes
    public func addRoute(_ route: Route) {
        self._router[route.relativeEndpoint.absoluteString] = route.response
    }
    
    public func removeRoute(_ route: Route) {
        self._router[route.relativeEndpoint.absoluteString] = nil
    }
}


// MARK: Class Declaration
open class LocalNode {
    // Init
    public init() {}
    
    // DRFNode Conformance
    public let baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Private Static Constants
    private static let _queryStringKey: String = "QUERY_STRING"
    
    // Private Constants
    private let _loop: SelectorEventLoop = try! SelectorEventLoop(selector: try! KqueueSelector())
    private let _router: Router = Router()
    
    // Private Lazy Variables
    private lazy var _backgroundQueue: DispatchQueue = self._createBackgroundQueue()
    private lazy var _server: HTTPServer = self._createServer()
}


// MARK: Protocol Conformances
extension LocalNode: DRFNode {
    open func relativeListURL<T: DRFListGettable>(for resourceType: T.Type) -> URL {
        return self.baseURL
    }
}


// MARK: // Private
// MARK: Lazy Variable Creation
private extension LocalNode {
    func _createBackgroundQueue() -> DispatchQueue {
        return DispatchQueue(
            label: "LocalNode-BackgroundQueue",
            qos: .background
        )
    }
    
    func _createServer() -> DefaultHTTPServer {
        return DefaultHTTPServer(
            eventLoop: self._loop,
            port: 8080,
            app: self._router.app
        )
    }
}


// MARK: Start / Stopp / Restart Server
private extension LocalNode {
    func _start() {
        try! self._server.start()
        self._backgroundQueue.async {
            self._loop.runForever()
        }
    }
    
    func _stop() {
        self._server.stop()
        self._loop.stop()
    }
    
    func _restart() {
        self.stop()
        self.start()
    }
}


// Routes
private extension LocalNode {
    // Typealiases
    typealias _ListResponseKeys = DRFDefaultListResponseKeys
    typealias _PaginationKeys = DRFDefaultPagination.Keys
}


// MARK: Create List Route
private extension LocalNode {
    func _createListRoute<T: LocalNodeListGettable>(for objectType: T.Type) -> Route {
        let response: WebApp = JSONResponse() {
            let urlParameters: [String : String] = self._extractURLParameters(fromEnviron: $0)
            
            let defaultLimit: Int = Int(objectType.defaultLimit)
            let maximumLimit: Int = Int(objectType.localNodeMaximumLimit)
            
            var limit: Int = defaultLimit
            if let _limit: String = urlParameters[_PaginationKeys.limit] {
                limit = min(Int(_limit) ?? defaultLimit, maximumLimit)
            }
            
            // Using '<=' instead of '<' is not strictly necessary here,
            // since LocalNodeListGettable.defaultLimit and .localNodeMaximumLimit
            // are both UInt. Still, this might prevent confusion if that type
            // requirement ever changes (although I can't think of any use case for
            // that which makes sense to me... :)
            if limit <= 0 {
                // ???: Actual DRF API behaviour?
                limit = defaultLimit
            }
            
            var offset: Int = 0
            if let _offset: String = urlParameters[_PaginationKeys.offset] {
                offset = max(0, Int(_offset) ?? 0)
            }
            
            let allObjects: [T] = T.allFixtureObjects
            let totalCount: Int = allObjects.count
            let totalEndIndex: Int = totalCount - 1
            
            var objectDicts: [[String : Any]] = []
            if offset > totalEndIndex {
                objectDicts = []
            } else {
                let endIndexOffset: Int = limit - 1
                let endIndex = min(offset + endIndexOffset, totalEndIndex)
                objectDicts = allObjects[offset...endIndex].map({ $0.toJSONDict() })
            }
            
            return [
                _ListResponseKeys.meta: [
                    _PaginationKeys.limit: limit,
                    _PaginationKeys.next: nil, // TODO:
                    _PaginationKeys.offset: offset,
                    _PaginationKeys.previous: nil, // TODO:
                    _PaginationKeys.totalCount: totalCount
                ],
                _ListResponseKeys.results: objectDicts
            ]
        }
        
        let endpoint: URL = self.relativeListURL(for: objectType)
        return (endpoint, response)
    }
    
    // Helpers
    func _extractURLParameters(fromEnviron environ: Parameters) -> [String : String] {
        let paramsString: String = environ[LocalNode._queryStringKey] as! String
        let params: [(String, String)] = URLParametersReader.parseURLParameters(paramsString)
        return Dictionary(uniqueKeysWithValues: params)
    }
}
