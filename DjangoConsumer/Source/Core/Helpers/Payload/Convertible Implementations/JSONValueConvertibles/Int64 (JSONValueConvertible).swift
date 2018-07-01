//
//  Int64 (JSONValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 01.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Int64: JSONValueConvertible {
    public func toJSONValue() -> Payload.JSON.Value {
        return .int64(self)
    }
}
