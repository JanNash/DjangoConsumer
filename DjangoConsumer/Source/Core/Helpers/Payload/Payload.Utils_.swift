//
//  Payload.Utils_.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 11.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Internal
extension Payload.Utils_ {
    static func merge(_ payloadElement: Payload.Element, to jsonPayload: inout Payload.JSON.UnwrappedPayload, and multipartPayload: inout Payload.Multipart.UnwrappedPayload) {
        if let json: Payload.JSON.UnwrappedPayload = payloadElement.json {
            jsonPayload.merge(json, strategy: .overwriteOldValue)
        }
        
        if let multipart: Payload.Multipart.UnwrappedPayload = payloadElement.multipart {
            multipartPayload.merge(multipart, strategy: .overwriteOldValue)
        }
    }
}
