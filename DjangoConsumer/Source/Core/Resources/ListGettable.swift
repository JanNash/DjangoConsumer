//
//  ListGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.01.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - ListGettable
// MARK: Protocol Declaration
public protocol ListGettable: ListResource, JSONInitializable {
    static var listGettableClients: [ListGettableClient] { get set }
}


// MARK: - ListGettableNoAuth
// MARK: Protocol Declaration
public protocol ListGettableNoAuth: ListGettable, NeedsNoAuthNode {}


// MARK: Default Implementations
public extension ListGettableNoAuth {
    static func get(from node: NoAuthNode = Self.defaultNoAuthNode, offset: UInt = 0, limit: UInt? = nil) {
        DefaultImplementations.ListGettable.get(self, from: node, offset: offset, limit: limit, filters: [])
    }
}


// MARK: - DefaultImplementations.ListGettable
public extension DefaultImplementations.ListGettable {
    public static func get<T: ListGettable>(_ listGettableType: T.Type, from node: NoAuthNode, offset: UInt, limit: UInt?, filters: [FilterType]) {
        self.get(listGettableType, from: node, via: node.sessionManagerNoAuth, offset: offset, limit: limit, filters: filters)
    }
    
    public static func get<T: ListGettable>(_ listGettableType: T.Type, from node: Node, via sessionManager: SessionManagerType, offset: UInt, limit: UInt?, filters: [FilterType]) {
        self._get(listGettableType, from: node, via: sessionManager, offset: offset, limit: limit, filters: filters)
    }
}


// MARK: // Private
private extension DefaultImplementations.ListGettable {
    static func _get<T: ListGettable>(_ l: T.Type, from node: Node, via sessionManager: SessionManagerType, offset: UInt, limit: UInt?, filters: [FilterType]) {
        let routeType: RouteType.List = .listGET
        let url: URL = node.absoluteURL(for: T.self, routeType: routeType)
        
        let limit: UInt = limit ?? node.defaultLimit(for: l)
        let parameters: JSONDict = node.parametersFrom(offset: offset, limit: limit, filters: filters)
        
        let encoding: ParameterEncoding = URLEncoding.default
        
        func onSuccess(_ json: JSON) {
            let (pagination, objects): (Pagination, [T]) = node.extractGETListResponse(for: T.self, from: json)
            let success: GETObjectListSuccess = GETObjectListSuccess(
                node: node, responsePagination: pagination, offset: offset, limit: limit, filters: filters
            )
            T.listGettableClients.forEach({ $0.gotObjects(objects: objects, with: success) })
        }
        
        func onFailure(_ error: Error) {
            let failure: GETObjectListFailure = GETObjectListFailure(
                objectType: T.self, node: node, error: error, offset: offset, limit: limit, filters: filters
            )
            T.listGettableClients.forEach({ $0.failedGettingObjects(with: failure) })
        }
        
        sessionManager.fireJSONRequest(
            with: RequestConfiguration(url: url, method: routeType.method, payload: .json(parameters), encoding: encoding),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
