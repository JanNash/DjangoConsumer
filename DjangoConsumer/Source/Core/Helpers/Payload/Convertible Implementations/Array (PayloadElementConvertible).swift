//
//  Array (PayloadElementConvertible).swift
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
extension Array: PayloadElementConvertible where Element: PayloadElementConvertible {
    public func toPayloadElement(path: String) -> Payload.Element {
        return self._toPayloadElement(path: path)
    }
}


// MARK: : PayloadElementConvertible Implementation
private extension Array/*: PayloadElementConvertible*/ where Element: PayloadElementConvertible {
    func _toPayloadElement(path: String) -> Payload.Element {
        var multipartPayloadValue: Payload.Multipart.RawPayloadValue = []
        let jsonPayloadValue: [Payload.JSON.RawPayloadValue] = self.enumerated().compactMap({
            let (offset, element): (Int, Element) = $0
            // FIXME: This should be extracted
            let path: String = path + "[" + "\(offset)" + "]"
            let payloadElement: Payload.Element = element.toPayloadElement(path: path)
        
            if let multipart: Payload.Multipart.RawPayloadValue = payloadElement.multipart {
                multipartPayloadValue += multipart
            }
            
            return payloadElement.json
        })
        
        return (jsonPayloadValue, multipartPayloadValue)
    }
}
