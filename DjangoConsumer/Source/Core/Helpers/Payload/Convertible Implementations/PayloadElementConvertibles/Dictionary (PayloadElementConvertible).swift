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
        var jsonPayload: Payload.JSON.UnwrappedPayload = [:]
        var multipartPayload: Payload.Multipart.UnwrappedPayload = [:]
        
        self.forEach({
            let (key, value): (String, Value) = $0
            // FIXME: The path creation should be extracted
            Payload.Utils_.merge(
                value.toPayloadElement(path: path + "." + key, pathHead: key),
                to: &jsonPayload,
                and: &multipartPayload
            )
        })
        
        return (jsonPayload, multipartPayload)
    }
}
