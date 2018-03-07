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
public protocol SinglePostable {
    init(json: JSON)
    func toParameters() -> Parameters
    static var singlePostableClients: [SinglePostableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension SinglePostable where Self: NeedsNoAuth {
    func post(to node: Node? = nil) {
        self.post_(to: node ?? Self.defaultNode)
    }
}


// MARK: // Internal
// MARK: Shared GET function
extension SinglePostable {
    func post_(to node: Node) {
        self._post(to: node)
    }
}


// MARK: // Private
// MARK: GET function Implementation
private extension SinglePostable {
    func _post(to node: Node) {
        let method: HTTPMethod = .post
        let url: URL = node.absoluteSinglePOSTURL(for: type(of: self))
        let parameters: Parameters = self.toParameters()
        let encoding: ParameterEncoding = JSONEncoding.default
        
        func onSuccess(_ json: JSON) {
            Self.singlePostableClients.forEach({ $0.postedObject(self, responseObject: .init(json: json), to: node)})
        }
        
        func onFailure(_ error: Error) {
            Self.singlePostableClients.forEach({ $0.failedPostingObject(self, to: node, with: error) })
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method, parameters: parameters, encoding: encoding) ,
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
