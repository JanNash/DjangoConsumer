//
//  Dictionary (PayloadElementConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - : PayloadElementConvertible
extension Dictionary: PayloadElementConvertible where Key == String, Value: PayloadElementConvertible {
    public func toPayloadElement(path: String, pathHead: String) -> Payload.Element {
        return self._toPayloadElement(path: path, pathHead: pathHead)
    }
}


// MARK: : PayloadElementConvertible Implementation
private extension Dictionary/*: PayloadElementConvertible*/ where Key == String, Value: PayloadElementConvertible {
    func _toPayloadElement(path: String, pathHead: String) -> Payload.Element {
        var multipartPayloadValue: Payload.Multipart.Payload = []
        var jsonPayloadValue: Payload.JSON.Payload = []
        
        self.forEach({ element in
            let (key, value): (String, Value) = element
            
            // FIXME: This should be extracted
            let path: String = path + "." + key
            let payloadValue: Payload.Element = value.toPayloadElement(path: path, pathHead: key)
            
            if let multipart: Payload.Multipart.Payload = payloadValue.multipart {
                multipartPayloadValue.append(contentsOf: multipart)
            }
            
            if let json: Payload.JSON.Payload = payloadValue.json {
                jsonPayloadValue.append(contentsOf: json)
            }
        })
        
        return (jsonPayloadValue, multipartPayloadValue)
    }
}
