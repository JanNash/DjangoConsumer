//
//  MockBackend.swift
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
// MARK: Public Interface
extension MockBackend {
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
open class MockBackend {
    // Init
    public init() {}
    
    // Overridables //
    // Obligatory
    
    // Quite necessary
    
    
    // Optional
    // Route Creation
    open func createPaginatedListResponse<T: MockBackendListGettable>(for objectType: T.Type) -> WebApp {
        return self._createPaginatedListResponse(for: objectType)
    }
    
    // Pagination for GET list endpoints
    open var defaultMaximumPaginationLimit: UInt = 200
    open func maximumPaginationLimit(for objectType: DRFListGettable.Type) -> UInt {
        return self.defaultMaximumPaginationLimit
    }
    
    // Fixture creation
    func fixtures<T: DRFListGettable>(for objectType: T.Type) -> [T] {
        // Fixtures can either be created dynamically inside this function,
        // or, to improve performance, they can be saved to variables which
        // are then returned from this function.
        return []
    }
    
    // Private Static Constants
    private static let _queryStringKey: String = "QUERY_STRING"
    
    // Private Constants
    private let _loop: SelectorEventLoop = try! SelectorEventLoop(selector: try! KqueueSelector())
    private let _router: Router = Router()
    
    // Private Lazy Variables
    private lazy var _backgroundQueue: DispatchQueue = self._createBackgroundQueue()
    private lazy var _server: HTTPServer = self._createServer()
}


// MARK: // Private
// MARK: Lazy Variable Creation
private extension MockBackend {
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
private extension MockBackend {
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
private extension MockBackend {
    typealias _ListResponseKeys = DRFDefaultListResponseKeys
    typealias _PaginationKeys = DRFDefaultPagination.Keys
    typealias _URLParameters = (pagination: _Pagination, filters: [String : String])
    
    struct _Pagination {
        var limit: Int?
        var offset: Int?
    }
}


// MARK: Create List Route
private extension MockBackend {
    func _createPaginatedListResponse<T: MockBackendListGettable>(for objectType: T.Type) -> WebApp {
        return JSONResponse() {
            let urlParameters: _URLParameters = self._readURLParameters(fromEnviron: $0)
            let (limit, offset): (Int, Int) = self._processPagination(urlParameters.pagination, for: objectType)
            let filterClosure: (T) -> Bool = T.mockBackendFilterClosure(for: urlParameters.filters)
            
            let allObjects: [T] = self.fixtures(for: objectType)
            let filteredObjects: [T] = allObjects.filter(filterClosure)
            // ???: How does DRF calculate the totalCount, for all objects or only for the filtered list?
            let totalCount: Int = filteredObjects.count
            let totalEndIndex: Int = totalCount - 1
            
            var objectDicts: [[String : Any]] = []
            if offset < totalEndIndex {
                let endIndexOffset: Int = limit - 1
                let endIndex = min(offset + endIndexOffset, totalEndIndex)
                objectDicts = filteredObjects[offset...endIndex].map({ $0.mockBackendToJSONDict() })
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
    }
    
    // Helpers
    func _readURLParameters(fromEnviron environ: Parameters) -> _URLParameters {
        let paramsString: String = environ[MockBackend._queryStringKey] as! String
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
    
    func _processPagination<T: DRFListGettable>(_ pagination: _Pagination, for objectType: T.Type) -> (limit: Int, offset: Int) {
        let defaultLimit: Int = Int(objectType.defaultLimit)
        let maximumLimit: Int = Int(self.maximumPaginationLimit(for: objectType))
        var limit: Int = min(maximumLimit, pagination.limit ?? defaultLimit)
        if limit <= 0 {
            // ???: Actual DRF API behaviour?
            limit = defaultLimit
        }
        let offset: Int = max(0, pagination.offset ?? 0)
        return (limit: limit, offset: offset)
    }
}
