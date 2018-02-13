//
//  DetailGettable.swift
//  DjangoConsumer
//
//  Created by Jan Nash (privat) on 13.02.18.
//  Copyright © 2018 Kitenow. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: Protocol Declaration
public protocol DetailGettable {
    init(json: JSON)
    var url: URL { get }
    var gotNewSelf: (Self, _ from: Node) -> Void { get }
    var failedGettingNewSelf: (_ from: Node, _ with: Error) -> Void { get }
    static var clients: [DetailGettableClient] { get set }
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
        let url: URL = node.absoluteDetailURL(for: self)
        
        ValidatedJSONRequest(url: url).fire(
            via: node.sessionManager,
            onSuccess: { result in
                let newSelf: Self = .init(json: result)
                self.gotNewSelf(newSelf, node)
                Self.clients.forEach({ $0.gotObject(newSelf, for: self, from: node)})
            },
            onFailure: { error in
                Self.clients.forEach({ $0.failedGettingObject(for: self, from: node, with: error) })
            }
        )
    }
}
