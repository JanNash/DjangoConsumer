//
//  Payload.Dict (PayloadConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: PayloadConvertible
extension Payload.Dict/*: PayloadConvertible*/ {
    public func payloadDict() -> Payload.Dict {
        return self
    }
    
    public func toPayload() -> Payload  {
        return self._toPayload()
    }
}


// MARK: // Private
// MARK: PayloadConvertible Implementation
private extension Payload.Dict/*: PayloadConvertible*/ {
    func _toPayload() -> Payload {
        var multipartPayload: Payload.Multipart.Payload = []
        let jsonPayload: Payload.JSON.Payload = Dictionary<String, Any>(
            self.dict_.compactMap({
                let (key, convertible): (String, PayloadElementConvertible) = $0
                let payloadElement: Payload.Element = convertible.toPayloadElement(path: key)
                
                if let multipart: Payload.Multipart.Payload = payloadElement.multipart {
                    multipartPayload = multipart
                }
                
                if let json: Any = payloadElement.json {
                    return (key, json)
                }
                
                return nil
            }),
            uniquingKeysWith: { _, r in r }
        )
        
        return Payload(json: jsonPayload, multipart: multipartPayload)
    }
}
