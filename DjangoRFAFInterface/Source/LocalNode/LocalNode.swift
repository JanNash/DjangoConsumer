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


// MARK: // Open
// MARK: Interface
extension LocalNode {
    // Typealiases
    typealias Route = (relativeEndpoint: URL, response: WebApp)
    
    // Functions
    open func start() {
        self._start()
    }
    
    open func stop() {
        self._stop()
    }
}


// MARK: Class Declaration
open class LocalNode {
    // DRFNode Conformance
    public let baseURL: URL = URL(string: "http://localhost:8080")!
    
    // Private Static Constants
    private static let _queryStringKey: String = "QUERY_STRING"
    
    // Private Constants
    private let _loop: SelectorEventLoop = try! SelectorEventLoop(selector: try! KqueueSelector())
    
    // Private Lazy Variables
    private lazy var _backgroundQueue: DispatchQueue = self._createBackgroundQueue()
    private lazy var _router: Router = self._createRouter()
    private lazy var _server: HTTPServer = self._createServer()
}


// MARK: Protocol Conformances
extension LocalNode: DRFNode {
    open func listEndpoint<T: DRFListGettable>(for resourceType: T.Type) -> URL {
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
    
    func _createRouter() -> Router {
        let router: Router = Router()
        self._addRoutes(to: router)
        return router
    }
    
    func _createServer() -> DefaultHTTPServer {
        return DefaultHTTPServer(
            eventLoop: self._loop,
            port: 8080,
            app: self._router.app
        )
    }
}


// MARK: Start Server
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
}


// Routes
private extension LocalNode {
    // Typealiases
    typealias _Route = (subpath: String, response: WebApp)
    typealias _ListResponseKeys = DRFListResponseKeys
    typealias _PaginationKeys = DRFDefaultPagination.Keys
    
    // All Routes
    func _addRoutes(to router: Router) {
        self._routes().forEach({
            router[$0.subpath] = $0.response
        })
    }
    
    func _routes() -> [_Route] {
        return self._list_routes() + self._detail_routes()
    }
    
    // List Routes
    func _list_routes() -> [_Route] {
        return [
            
        ]
    }
    
    // Detail Routes
    func _detail_routes() -> [_Route] {
        return []
    }
    
    // Create List Route
    func _list_route<T: DRFListGettable>(for objectType: T.Type) -> _Route {
        let response: WebApp = JSONResponse() {
            environ -> Any in
            
            let defaultLimit: Int = Int(objectType.defaultLimit)
            //            let maximumLimit: Int = objectType.maximumLimit
            
            let paramsString: String = environ[LocalNode._queryStringKey] as! String
            let params: [(String, String)] = URLParametersReader.parseURLParameters(paramsString)
            let paramDict: [String : String] = Dictionary(uniqueKeysWithValues: params)
            
            var limit: Int = defaultLimit
            if let _limit: String = paramDict[_PaginationKeys.limit] {
                limit = max(0, min(Int(_limit) ?? defaultLimit, 200)) // FIXME:
            }
            
            var offset: Int = 0
            if let _offset: String = paramDict[_PaginationKeys.offset] {
                offset = max(0, Int(_offset) ?? 0)
            }
            
            //            let allObjects: [T] = T.allFixtureObjects
            let allObjects: [T] = []
            let totalCount: Int = allObjects.count
            let totalEndIndex: Int = totalCount - 1
            
            var objectDicts: [[String : Any]] = []
            if offset > totalEndIndex {
                objectDicts = []
            }
            
            let endIndexOffset: Int = limit - 1
            let endIndex = min(offset + endIndexOffset, totalEndIndex)
            //            objectDicts = allObjects[offset...endIndex].map(JSON(T))
            
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
        
        let endpoint: String = self.listEndpoint(for: objectType).absoluteString
        return (endpoint, response)
    }
}
