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


// MARK: - IdentifiableResource
// ???: Does this have to be a refinement of DetailResource
public protocol IdentifiableResource: DetailResource {
    var id: ResourceID<Self>? { get }
}


// MARK: - IdentifiableResourceError
public enum IdentifiableResourceError: Error {
    case hasNoID
}


// MARK: - ResourceID
// MARK: Struct Declaration
public struct ResourceID<T: DetailResource> {
    public init(_ string: String) { self.string = string }
    public private(set) var string: String
}


// MARK: Default Implementations
// MARK: where T: DetailGettable & NeedsNoAuth
public extension ResourceID where T: DetailGettable & NeedsNoAuth {
    func get(from node: Node = T.defaultNode) {
        DefaultImplementations._ResourceID_.getResource(withID: self, from: node)
    }
}


// MARK: - DefaultImplementations._ResourceID_
// MARK: where T: DetailGettable
public extension DefaultImplementations._ResourceID_ {
    public static func getResource<T: DetailGettable>(withID resourceID: ResourceID<T>, from node: Node) {
        self._getResource(withID: resourceID, from: node)
    }
}


// MARK: // Private
// MARK: where T: DetailGettable
private extension DefaultImplementations._ResourceID_ {
    static func _getResource<T: DetailGettable>(withID resourceID: ResourceID<T>, from node: Node) {
        let url: URL = node.absoluteGETURL(for: resourceID)
        let method: ResourceHTTPMethod = .get
        let encoding: ParameterEncoding = URLEncoding.default

        func onSuccess(_ json: JSON) {
            let object: T = node.extractSingleObject(for: T.self, method: method, from: json)
            T.detailGettableClients.forEach({ $0.gotObject(object, for: resourceID, from: node)})
        }
        
        func onFailure(_ error: Error) {
            T.detailGettableClients.forEach({ $0.failedGettingObject(for: resourceID, from: node, with: error) })
        }
        
        node.sessionManager.fireJSONRequest(
            with: RequestConfiguration(url: url, method: method, encoding: encoding),
            responseHandling: JSONResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
