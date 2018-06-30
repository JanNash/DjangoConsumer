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
public protocol ListPostable: ListResource, JSONInitializable, PayloadConvertible {
    static var listPostableClients: [ListPostableClient] { get set }
}


// MARK: - ListPostableNoAuth
// MARK: Protocol Declaration
public protocol ListPostableNoAuth: ListPostable, NeedsNoAuthNode {}


// MARK: - Collection
// MARK: where Self.Element: ListPostableNoAuth
public extension Collection where Self.Element: ListPostableNoAuth {
    public func post(to node: NoAuthNode = Self.Element.defaultNoAuthNode) {
        DefaultImplementations.ListPostable.post(self, to: node)
    }
}


// MARK: - DefaultImplementations.ListPostable
public extension DefaultImplementations.ListPostable {
    public static func post<C: Collection, T: ListPostable>(_ objects: C, to node: NoAuthNode) where C.Element == T {
        self.post(objects, to: node, via: node.sessionManagerNoAuth)
    }
    
    public static func post<C: Collection, T: ListPostable>(_ objects: C, to node: Node, via sessionManager: SessionManagerType) where C.Element == T {
        self._post(objects, to: node, via: sessionManager)
    }
}


// MARK: // Private
private extension DefaultImplementations.ListPostable {
    static func _post<C: Collection, T: ListPostable>(_ objects: C, to node: Node, via sessionManager: SessionManagerType) where C.Element == T {
        let routeType: RouteType.List = .listPOST
        let url: URL = node.absoluteURL(for: T.self, routeType: routeType)
        let payload: RequestPayload = node.payloadFrom(listPostables: objects)
        let unwrappedPayload: RequestPayload.Unwrapped = node.unwrapPayload(payload, for: objects)
        let encoding: ParameterEncoding = URLEncoding.default
        
        func onSuccess(_ json: JSON) {
            let responseObjects: [T] = node.extractPOSTListResponse(for: T.self, from: json)
            T.listPostableClients.forEach({ $0.postedObjects(objects, responseObjects: responseObjects, to: node) })
        }
        
        func onFailure(_ error: Error) {
            T.listPostableClients.forEach({ $0.failedPostingObjects(objects, to: node, with: error) })
        }
        
        sessionManager.fireRequest(
            with: .post(POSTRequestConfiguration(url: url, payload: unwrappedPayload, encoding: encoding)),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
