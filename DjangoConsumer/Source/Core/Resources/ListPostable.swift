//
//  ListPostable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - ListPostable
// MARK: Protocol Declaration
public protocol ListPostable: ListResource, JSONInitializable, ParameterConvertible {
    static var listPostableClients: [ListPostableClient] { get set }
}


// MARK: - ListPostableNoAuth
// MARK: Protocol Declaration
public protocol ListPostableNoAuth: ListPostable {
    static var listPOSTdefaultNode: Node { get }
}


// MARK: - Collection
// MARK: where Self.Element: ListPostableNoAuth
public extension Collection where Self.Element: ListPostableNoAuth {
    public func post(to node: Node = Self.Element.listPOSTdefaultNode) {
        DefaultImplementations._ListPostable_.post(self, to: node, via: node.sessionManager)
    }
}


// MARK: - DefaultImplementations._ListPostable_
public extension DefaultImplementations._ListPostable_ {
    public static func post<C: Collection, T: ListPostable>(_ objects: C, to node: Node, via sessionManager: SessionManagerType) where C.Element == T {
        self._post(objects, to: node, via: sessionManager)
    }
}


// MARK: // Private
private extension DefaultImplementations._ListPostable_ {
    static func _post<C: Collection, T: ListPostable>(_ objects: C, to node: Node, via sessionManager: SessionManagerType) where C.Element == T {
        let routeType: RouteType.List = .listPOST
        let url: URL = node.absoluteURL(for: T.self, routeType: routeType)
        let parameters: Parameters = node.parametersFrom(listPostables: objects)
        let encoding: ParameterEncoding = URLEncoding.default
        
        func onSuccess(_ json: JSON) {
            let responseObjects: [T] = node.extractPOSTListResponse(for: T.self, from: json)
            T.listPostableClients.forEach({ $0.postedObjects(objects, responseObjects: responseObjects, to: node) })
        }
        
        func onFailure(_ error: Error) {
            T.listPostableClients.forEach({ $0.failedPostingObjects(objects, to: node, with: error) })
        }
        
        sessionManager.fireJSONRequest(
            with: RequestConfiguration(url: url, method: routeType.method, parameters: parameters, encoding: encoding),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
