//
//  Dictionary (PayloadValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 28.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Internal
// MARK: - : PayloadValueConvertible
extension Dictionary: PayloadValueConvertible where Key == String, Value: PayloadValueConvertible {
    func mapToPayloadValue(path: String) -> Payload.Value {
        return self._mapToPayloadValue(path: path)
    }
}


// MARK: : PayloadValueConvertible Implementation
private extension Dictionary/*: PayloadValueConvertible*/ where Key == String, Value: PayloadValueConvertible {
    func _mapToPayloadValue(path: String) -> Payload.Value {
        var multipartDict: [String: Payload.Multipart.Value] = [:]
        
        let jsonDict: [String: Any] = Dictionary<String, Any>(
            self.compactMap({ element in
                // FIXME: This should be extracted
                let path: String = path + "." + element.key
                let payloadValue: Payload.Value = element.value.mapToPayloadValue(path: path)
                
                multipartDict.merge(payloadValue.multipart, uniquingKeysWith: { _, r in r })
                
                if let json = payloadValue.json {
                    return (element.key, json)
                }
                
                return nil
            }),
            uniquingKeysWith: { _, r in r }
        )
        
        return (jsonDict, multipartDict)
    }
}
