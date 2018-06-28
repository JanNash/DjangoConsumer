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
    public func splitToPayloadElement(path: String) -> Payload.Element {
        return self._splitToPayloadElement(path: path)
    }
}


// MARK: : PayloadElementConvertible Implementation
private extension Array/*: PayloadElementConvertible*/ where Element: PayloadElementConvertible {
    func _splitToPayloadElement(path: String) -> Payload.Element {
        var multipartDict: [String: Payload.Multipart.Value] = [:]
        
        let jsonArray: [Any] = self.enumerated().compactMap({
            let (offset, element): (Int, Element) = $0
            // FIXME: This should be extracted
            let path: String = path + "[" + "\(offset)" + "]"
            let payloadValue: Payload.Element = element.splitToPayloadElement(path: path)
        
            multipartDict.merge(payloadValue.multipart, uniquingKeysWith: { _, r in r })
            
            return payloadValue.json
        })
        
        return (jsonArray, multipartDict)
    }
}
