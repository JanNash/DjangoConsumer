//
//  DetailGettable.swift
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
// MARK: Protocol Declaration
public protocol DetailGettable: DetailResource {
    init(json: JSON)
    func gotNewSelf(_ newSelf: Self, from: Node)
    func failedGettingNewSelf(from: Node, with error: Error)
    static var detailGettableClients: [DetailGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsNoAuth {
    func get(from node: Node? = nil) {
        self._get(from: node ?? Self.defaultNode)
    }
}


// MARK: // Internal
// MARK: Shared GET function
extension DetailGettable {
    func get_(from node: Node) {
        self._get(from: node)
    }
}


// MARK: // Private
// MARK: GET function Implementation
private extension DetailGettable {
    func _get(from node: Node) {
        let method: HTTPMethod = .get
        let url: URL = node.absoluteDetailURL(for: self, method: method)
        
        func onSuccess(_ json: JSON) {
            let newSelf: Self = .init(json: json)
            Self.detailGettableClients.forEach({ $0.gotObject(newSelf, for: self, from: node)})
            self.gotNewSelf(newSelf, from: node)
        }
        
        func onFailure(_ error: Error) {
            Self.detailGettableClients.forEach({ $0.failedGettingObject(for: self, from: node, with: error) })
            self.failedGettingNewSelf(from: node, with: error)
        }
        
        node.sessionManager.fireJSONRequest(
            cfg: RequestConfiguration(url: url, method: method),
            responseHandling: ResponseHandling(onSuccess: onSuccess, onFailure: onFailure)
        )
    }
}
