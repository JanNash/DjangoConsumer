//
//  DetailResource.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 13.02.18.
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
// MARK: - DetailResource
public protocol DetailResource: MetaResource {}


// MARK: - ResourceID
// MARK: Struct Declaration
public struct ResourceID<T: DetailResource> {
    public init(_ id: String) { self.id = id }
    public private(set) var id: String
}


// MARK: Default Implementations
// MARK: where T: DetailGettable & NeedsNoAuth
public extension ResourceID where T: DetailGettable & NeedsNoAuth {
    func get(from node: Node = T.defaultNode) {
        self._get(from: node)
    }
}


// MARK: // Internal
// MARK: Common GET function
extension ResourceID where T: DetailGettable {
    func get_(from node: Node) {
        self._get(from: node)
    }
}


// MARK: // Private
// MARK: where T: DetailGettable
private extension ResourceID where T: DetailGettable {
    func _get(from node: Node) {
        let method: HTTPMethod = .get
        let url: URL = node.absoluteDetailURL(for: self, method: method)

        func onSuccess(_ json: JSON) {
            let object: T = T.init(json: json)
            T.detailGettableClients.forEach({ $0.gotObject(object, for: self, from: node)})
        }
        
        func onFailure(_ error: Error) {
            T.detailGettableClients.forEach({ $0.failedGettingObject(for: self, from: node, with: error) })
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method),
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
