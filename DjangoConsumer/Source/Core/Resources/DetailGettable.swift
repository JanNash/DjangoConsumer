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
    static var clients: [DetailGettableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth
public extension DetailGettable where Self: NeedsNoAuth {
    func get(from node: Node? = nil) {
        self._get(from: node ?? self.defaultNode)
    }
}


// MARK: // Private
// MARK: Shared GET function Implementation
private extension DetailGettable {
    func _get(from node: Node) {
        let url: URL = node.absoluteURL(for: self)
        
        ValidatedJSONRequest(url: url, parameters: parameters).fire(
            via: node.sessionManager,
            onSuccess: { result in
                
            },
            onFailure: { error in
                
            }
        )
    }
}
