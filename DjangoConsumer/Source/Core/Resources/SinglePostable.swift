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

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol SinglePostable: DetailResource {
    init(json: JSON)
    func toParameters() -> Parameters
    static var singlePostableClients: [SinglePostableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension SinglePostable where Self: NeedsNoAuth {
    func post(to node: Node? = nil) {
        DefaultSinglePostableImplementations.post(self, to: node ?? Self.defaultNode)
    }
}


// MARK: // Internal
// MARK: DefaultSinglePostableImplementations
public struct DefaultSinglePostableImplementations {
    public static func post<T: SinglePostable>(_ singlePostable: T, to node: Node) {
        self._post(singlePostable, to: node)
    }
}


// MARK: // Private
private extension DefaultSinglePostableImplementations {
    static func _post<T: SinglePostable>(_ singlePostable: T, to node: Node) {
        let method: HTTPMethod = .post
        let url: URL = node.absoluteURL(for: singlePostable, method: method)
        let parameters: Parameters = singlePostable.toParameters()
        let encoding: ParameterEncoding = JSONEncoding.default
        
        func onSuccess(_ json: JSON) {
            T.singlePostableClients.forEach({ $0.postedObject(singlePostable, responseObject: T.init(json: json), to: node)})
        }
        
        func onFailure(_ error: Error) {
            T.singlePostableClients.forEach({ $0.failedPostingObject(singlePostable, to: node, with: error) })
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method, parameters: parameters, encoding: encoding),
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
