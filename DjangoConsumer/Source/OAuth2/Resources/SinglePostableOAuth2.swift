//
//  SinglePostableOAuth2.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 06.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD 3 Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Alamofire


// MARK: // Public
// MARK: Protocol Declaration
public protocol SinglePostableOAuth2: SinglePostable, NeedsOAuth2Node {}


// MARK: Default Implementations
public extension SinglePostableOAuth2 {
    func post(to node: OAuth2Node = Self.defaultOAuth2Node, conversion: PayloadConversion = DefaultPayloadConversion()) {
        DefaultImplementations.SinglePostable.post(
            self, to: node, additionalHeaders: [:], additionalParameters: [:], conversion: conversion
        )
    }
}


// MARK: - DefaultImplementations.SinglePostable
public extension DefaultImplementations.SinglePostable {
    static func post<T: SinglePostable>(_ singlePostable: T, to node: OAuth2Node, additionalHeaders: HTTPHeaders, additionalParameters: Payload.JSON.Dict, conversion: PayloadConversion) {
        self.post(singlePostable, to: node, via: node.sessionManagerOAuth2, additionalHeaders: additionalHeaders, additionalParameters: additionalParameters, conversion: conversion)
    }
}
