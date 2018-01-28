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
    public typealias Response = (String) -> WebApp
    public typealias Route = (regexPattern: String, responseFor: Response)
    public typealias FilterClosure = (DRFListGettable) -> Bool
    
    // Functions
    // Start / Stop & Reset
    public func start() {
        self._start()
    }
    
    public func stopAndReset() {
        self._stopAndReset()
    }
    
    public func resetRouter() {
        self._resetRouter()
    }
    
    // Adding / Removing Routes
    public func addRoute(_ route: Route) {
        self._addRoute(route)
    }
    
    public func removeRoute(_ route: Route) {
        self._router[route.regexPattern] = nil
    }
}


// MARK: Class Declaration
open class MockBackend {
    // Init
    public init() {}
    
    // Overridables //
    // Quite necessary
    // Filtering for GET list endpoints
    open func filterClosure(for queryParameters: Parameters, with routePattern: String) -> FilterClosure {
        // ???: Should an override be forced by a fatal error here?
        return { _ in true }
    }
    
    // Fixture creation
    open func fixtures(for routePattern: String) -> [DRFListGettable] {
        // ???: Should an override be forced by a fatal error here?
        // Fixtures can either be created dynamically inside this function,
        // or, to improve performance, they can be saved to variables which
        // are then returned from this function.
        return []
    }
    
    // Converting objects to JSON dictionaries
    open func createJSONDict(from object: DRFListGettable, for routePattern: String) -> [String : Any] {
        // ???: Should an override be forced by a fatal error here?
        return [:]
    }
    
    // Optional
    // Port
    open var port: Int = 8080
    
    // Route Creation
    open func filteredPaginatedListResponse(routePattern: String) -> WebApp {
        return self._filteredPaginatedListResponse(for: routePattern)
    }
    
    // Pagination for GET list endpoints
    open var instanceDefaultPaginationLimit: UInt = 100
    open func defaultPaginationLimit(for routePattern: String) -> UInt {
        return self.instanceDefaultPaginationLimit
    }
    
    open var instanceMaximumPaginationLimit: UInt = 200
    open func maximumPaginationLimit(for routePattern: String) -> UInt {
        return self.instanceMaximumPaginationLimit
    }
    
    
    // Implementation //
    // Private Static Constants
    private static let _queryStringKey: String = "QUERY_STRING"
    
    // Private Variable
    private var _router: Router = Router()
    
    // Private Lazy Variables
    private lazy var _loop: SelectorEventLoop = self._createLoop()
    private lazy var _backgroundQueue: DispatchQueue = self._createBackgroundQueue()
    private lazy var _server: HTTPServer = self._createServer()
}


// MARK: // Private
// MARK: Lazy Variable Creation
private extension MockBackend {
    func _createLoop() -> SelectorEventLoop {
        return try! SelectorEventLoop(selector: try! KqueueSelector())
    }
    
    func _createBackgroundQueue() -> DispatchQueue {
        return DispatchQueue(
            label: "LocalNode-BackgroundQueue",
            qos: .background
        )
    }
    
    func _createServer() -> DefaultHTTPServer {
        return DefaultHTTPServer(
            eventLoop: self._loop,
            port: self.port,
            app: self._router.app
        )
    }
}


// MARK: Start / Stopp / Restart Server
private extension MockBackend {
    func _start() {
        try! self._server.start()
        self._backgroundQueue.async() {
            self._loop.runForever()
        }
    }
    
    func _stopAndReset() {
        // Stop
        self._server.stop()
        self._loop.stop()
        
        // Reset
        self._loop = self._createLoop()
        self._backgroundQueue = self._createBackgroundQueue()
        self._server = self._createServer()
    }
    
    func _resetRouter() {
        let newRouter: Router = Router()
        self._router = newRouter
        self._server.app = newRouter.app
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


// MARK: Add Route Implementation
private extension MockBackend {
    func _addRoute(_ route: Route) {
        let regexPattern: String = route.regexPattern
        let webApp: WebApp = route.responseFor(regexPattern)
        self._router[regexPattern] = webApp
    }
}


// MARK: Create List Route
private extension MockBackend {
    func _filteredPaginatedListResponse(for routePattern: String) -> WebApp {
        return JSONResponse() {
            let urlParameters: _URLParameters = self._readURLParameters(fromEnviron: $0)
            let (limit, offset): (Int, Int) = self._processPagination(urlParameters.pagination, for: routePattern)
            let filterClosure: FilterClosure = self.filterClosure(for: urlParameters.filters, with: routePattern)
            
            let allObjects: [DRFListGettable] = self.fixtures(for: routePattern)
            let filteredObjects: [DRFListGettable] = allObjects.filter(filterClosure)
            // ???: How does DRF calculate the totalCount, for all objects or only for the filtered list?
            let totalCount: Int = filteredObjects.count
            let totalEndIndex: Int = totalCount - 1
            
            var objectDicts: [[String : Any]] = []
            if offset < totalEndIndex {
                let endIndexOffset: Int = limit - 1
                let endIndex = min(offset + endIndexOffset, totalEndIndex)
                let mapper: (DRFListGettable) -> [String : Any] = { self.createJSONDict(from: $0, for: routePattern) }
                objectDicts = filteredObjects[offset...endIndex].map(mapper)
            }
            
            // TODO: Calculate pagination response values for next and previous
            return [
                _ListResponseKeys.meta: [
                    _PaginationKeys.limit: limit,
                    _PaginationKeys.next: nil,
                    _PaginationKeys.offset: offset,
                    _PaginationKeys.previous: nil,
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
    
    func _processPagination(_ pagination: _Pagination, for routePattern: String) -> (limit: Int, offset: Int) {
        let defaultLimit: Int = Int(self.defaultPaginationLimit(for: routePattern))
        let maximumLimit: Int = Int(self.maximumPaginationLimit(for: routePattern))
        var limit: Int = min(maximumLimit, pagination.limit ?? defaultLimit)
        if limit <= 0 {
            // ???: Actual DRF API behaviour?
            limit = defaultLimit
        }
        let offset: Int = max(0, pagination.offset ?? 0)
        return (limit: limit, offset: offset)
    }
}