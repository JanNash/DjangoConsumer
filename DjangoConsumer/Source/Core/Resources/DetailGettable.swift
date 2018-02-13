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
// ???: I'm not happy with the class requirement
// but in order to be able to live-update the instance that get was called on,
// I couldn't find another way. Maybe the live-updating is a stupid idea after all?
public protocol DetailGettable: class {
    func update(from json: JSON)
    var url: URL { get }
    static var clients: [DetailGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsNoAuth {
    func get(from node: Node? = nil) {
        self._get(from: node ?? Self.defaultNode)
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
                self.update(from: result)
                Self.clients.forEach({ $0.gotObject(object: self) })
            },
            onFailure: { error in
                Self.clients.forEach({ $0.failedGettingObject(self, with: error) })
            }
        )
    }
}
