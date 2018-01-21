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
    
    // Adding / Removing Routes
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


// MARK: Routes
// MARK: Helper Types
private extension LocalNode {
    typealias _ListResponseKeys = DRFDefaultListResponseKeys
    typealias _PaginationKeys = DRFDefaultPagination.Keys
    typealias _URLParameters = (pagination: _Pagination, filters: [String : String])
    
    struct _Pagination {
        var limit: Int?
        var offset: Int?
        
        func processedFor<T: LocalNodeListGettable>(objectType: T.Type) -> (limit: Int, offset: Int) {
            let defaultLimit: Int = Int(objectType.defaultLimit)
            let maximumLimit: Int = Int(objectType.localNodeMaximumLimit)
            var limit: Int = min(maximumLimit, self.limit ?? defaultLimit)
            if limit <= 0 {
                // ???: Actual DRF API behaviour?
                limit = defaultLimit
            }
            let offset: Int = max(0, self.offset ?? 0)
            return (limit: limit, offset: offset)
        }
    }
}


// MARK: Create List Route
private extension LocalNode {
    func _createListRoute<T: LocalNodeListGettable>(for objectType: T.Type) -> Route {
        let response: WebApp = JSONResponse() {
            let urlParameters: _URLParameters = self._readURLParameters(fromEnviron: $0)
            let (limit, offset): (Int, Int) = urlParameters.pagination.processedFor(objectType: objectType)
            let filterClosure: (T) -> Bool = T.filterClosure(for: urlParameters.filters)
            
            let filteredObjects: [T] = T.allFixtureObjects.filter(filterClosure)
            // ???: How does DRF calculate the totalCount, for all objects or only for the filtered list?
            let totalCount: Int = filteredObjects.count
            let totalEndIndex: Int = totalCount - 1
            
            var objectDicts: [[String : Any]] = []
            if offset < totalEndIndex {
                let endIndexOffset: Int = limit - 1
                let endIndex = min(offset + endIndexOffset, totalEndIndex)
                objectDicts = filteredObjects[offset...endIndex].map({ $0.toJSONDict() })
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
    func _readURLParameters(fromEnviron environ: Parameters) -> _URLParameters {
        let paramsString: String = environ[LocalNode._queryStringKey] as! String
        let params: [(String, String)] = URLParametersReader.parseURLParameters(paramsString)
        var paramDict: [String : String] = Dictionary(uniqueKeysWithValues: params)
        // This call actually extracts the pagination key value pairs from the paramDict,
        // so the remainder should only be filters. Might this be subject for change?
        let pagination: _Pagination = self._extractPagination(fromParamDict: &paramDict)
        return (pagination, paramDict)
    }
    
    func _extractPagination(fromParamDict paramDict: inout [String : String]) -> _Pagination {
        return _Pagination(
            limit: Int(paramDict.removeValue(forKey: _PaginationKeys.limit) ?? "not a UInt"),
            offset: Int(paramDict.removeValue(forKey: _PaginationKeys.offset) ?? "not a UInt")
        )
    }
}
