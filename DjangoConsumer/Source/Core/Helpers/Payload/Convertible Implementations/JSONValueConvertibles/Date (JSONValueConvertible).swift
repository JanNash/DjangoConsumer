//
//  Date (JSONValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 22.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: Protocol Conformance
extension Date: JSONValueConvertible {
    public func toJSONValue() -> Payload.JSON.Value {
        return self._toJSONValue()
    }
}


// MARK: // Private
private extension Date/*: JSONValueConvertible */ {
    func _toJSONValue() -> Payload.JSON.Value {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return .string(formatter.string(from: self))
    }
}
