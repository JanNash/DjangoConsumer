//
//  DetailPostable.swift
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
public protocol DetailPostable: DetailResource {
    init(json: JSON)
    func toParameters() -> Parameters
    func postedSelf(_ responseSelf: Self, to: Node)
    func failedPostingSelf(to: Node, with error: Error)
    static var detailPostableClients: [DetailPostableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension DetailPostable where Self: NeedsNoAuth {
    func post(to node: Node? = nil) {
        self._post(to: node ?? Self.defaultNode)
    }
}


// MARK: // Internal
// MARK: Shared GET function
extension DetailPostable {
    func post_(to node: Node) {
        self._post(to: node)
    }
}


// MARK: // Private
// MARK: GET function Implementation
private extension DetailPostable {
    func _post(to node: Node) {
        let method: HTTPMethod = .post
        let url: URL = node.absoluteDetailURL(for: self, method: method)
        let parameters: Parameters = self.toParameters()
        let encoding: ParameterEncoding = JSONEncoding.default
        
        func onSuccess(_ json: JSON) {
            let responseSelf: Self = .init(json: json)
            Self.detailPostableClients.forEach({ $0.postedObject(self, responseObject: responseSelf, to: node)})
            self.postedSelf(responseSelf, to: node)
        }
        
        func onFailure(_ error: Error) {
            Self.detailPostableClients.forEach({ $0.failedPostingObject(self, to: node, with: error) })
            self.failedPostingSelf(to: node, with: error)
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method, parameters: parameters, encoding: encoding) ,
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
