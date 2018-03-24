//
//  ListPostable.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 24.03.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON


// MARK: // Public
// MARK: - ListPostable
// MARK: Protocol Declaration
public protocol ListPostable: ListResource, JSONInitializable, ParameterConvertible {
    static var listPostableClients: [ListPostableClient] { get set }
}


// MARK: - Collection
// MARK: where Self.Element: ListPostable & NeedsNoAuth
public extension Collection where Element: ListPostable & NeedsNoAuth {
    public func post(to node: Node = Element.defaultNode) {
        DefaultImplementations._ListPostable_.post(self, to: node)
    }
}


// MARK: - DefaultImplementations._ListPostable_
public extension DefaultImplementations._ListPostable_ {
    public static func post<C: Collection, T: ListPostable>(_ objects: C, to node: Node) where C.Element == T {
        self._post(objects, to: node)
    }
}


// MARK: // Private
private extension DefaultImplementations._ListPostable_ {
    static func _post<C: Collection, T: ListPostable>(_ objects: C, to node: Node) where C.Element == T {
        
    }
}
