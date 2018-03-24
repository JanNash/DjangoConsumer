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
// MARK: Protocol Declaration
public protocol ListPostable: ListResource, JSONInitializable {
    static var listPostableClients: [ListPostableClient] { get set }
}


// MARK: Default Implementations
// MARK: where Self: NeedsNoAuth



// MARK: - DefaultImplementations._ListPostable_
public extension DefaultImplementations._ListPostable_ {
    
}


// MARK: // Private
private extension DefaultImplementations._ListPostable_ {
    
}
