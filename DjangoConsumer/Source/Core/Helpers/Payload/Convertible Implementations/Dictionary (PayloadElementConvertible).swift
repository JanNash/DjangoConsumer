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
    public func toPayloadElement(path: String) -> Payload.Element {
        return self._toPayloadElement(path: path)
    }
}


// MARK: : PayloadElementConvertible Implementation
private extension Dictionary/*: PayloadElementConvertible*/ where Key == String, Value: PayloadElementConvertible {
    func _toPayloadElement(path: String) -> Payload.Element {
        var multipartPayloadValue: Payload.Multipart.RawPayloadValue = []
        let jsonPayloadValue: Payload.JSON.RawPayloadValue = Dictionary<String, Any>(
            self.compactMap({ element in
                // FIXME: This should be extracted
                let path: String = path + "." + element.key
                let payloadValue: Payload.Element = element.value.toPayloadElement(path: path)
                
                if let multipart: Payload.Multipart.RawPayloadValue = payloadValue.multipart {
                    multipartPayloadValue.append(contentsOf: multipart)
                }
                
                if let json: Payload.JSON.RawPayloadValue = payloadValue.json {
                    return (element.key, json)
                }
                
                return nil
            }),
            strategy: .overwriteOldValue
        )
        
        return (jsonPayloadValue, multipartPayloadValue)
    }
}
