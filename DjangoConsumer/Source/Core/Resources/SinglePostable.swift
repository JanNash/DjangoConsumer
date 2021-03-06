//
//  SinglePostable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 06.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: - SinglePostable
// MARK: Protocol Declaration
public protocol SinglePostable: DetailResource, JSONInitializable, PayloadConvertible {
    static var singlePostableClients: [SinglePostableClient] { get set }
}


// MARK: - SinglePostableNoAuth
// MARK: Protocol Declaration
public protocol SinglePostableNoAuth: SinglePostable, NeedsNoAuthNode {}


// MARK: Default Implementations
public extension SinglePostableNoAuth {
    func post(to node: NoAuthNode = Self.defaultNoAuthNode, conversion: PayloadConversion = DefaultPayloadConversion()) {
        DefaultImplementations.SinglePostable.post(
            self, to: node, via: node.sessionManagerNoAuth, additionalHeaders: [:], additionalParameters: [:], conversion: conversion
        )
    }
}


// MARK: - DefaultImplementations.SinglePostable
public extension DefaultImplementations.SinglePostable {
    static func post<T: SinglePostable>(_ singlePostable: T, to node: NoAuthNode, additionalHeaders: HTTPHeaders, additionalParameters: Payload.JSON.Dict, conversion: PayloadConversion) {
        self.post(singlePostable, to: node, via: node.sessionManagerNoAuth, additionalHeaders: additionalHeaders, additionalParameters: additionalParameters, conversion: conversion)
    }
    
    static func post<T: SinglePostable>(_ singlePostable: T, to node: Node, via sessionManager: SessionManagerType, additionalHeaders: HTTPHeaders, additionalParameters: Payload.JSON.Dict, conversion: PayloadConversion) {
        self._post(singlePostable, to: node, via: sessionManager, additionalHeaders: additionalHeaders, additionalParameters: additionalParameters, conversion: conversion)
    }
}


// MARK: // Private
private extension DefaultImplementations.SinglePostable {
    private static func _post<T: SinglePostable>(_ singlePostable: T, to node: Node, via sessionManager: SessionManagerType, additionalHeaders: HTTPHeaders, additionalParameters: Payload.JSON.Dict, conversion: PayloadConversion) {
        let routeType: RouteType.Detail = .singlePOST
        let method: ResourceHTTPMethod = routeType.method
        let url: URL = node.absoluteURL(for: T.self, routeType: routeType)
        
        let payload: Payload = node
            .payloadFrom(object: singlePostable, method: method, conversion: conversion)
            .merging(additionalParameters, conversion: conversion)
        
        let encoding: ParameterEncoding = JSONEncoding.default
        
        func onSuccess(_ json: JSON) {
            let responseObject: T = node.extractSingleObject(for: T.self, method: method, from: json)
            T.singlePostableClients.forEach({ $0.postedObject(singlePostable, responseObject: responseObject, to: node)})
        }
        
        func onFailure(_ error: Error) {
            T.singlePostableClients.forEach({ $0.failedPostingObject(singlePostable, to: node, with: error) })
        }
        
        sessionManager.fireRequest(
            with: .post(POSTRequestConfiguration(url: url, payload: payload, encoding: encoding, headers: additionalHeaders)),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
