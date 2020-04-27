//
//  Optional (MultipartValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash (resmio) on 27.04.20.
//  Copyright © 2020 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
extension Optional: MultipartValueConvertible where Wrapped: MultipartValueConvertible {
    public func toMultipartValue() -> Payload.Multipart.Value {
        return self._toMultipartValue()
    }
}


// MARK: // Private
private extension Optional where Wrapped: MultipartValueConvertible {
    func _toMultipartValue() -> Payload.Multipart.Value {
        switch self {
        case .some(let value): return value.toMultipartValue()
        case .none:
            // FIXME: What contentType should be returned here?
            // ???: Is it ok to naively use application/json? Check RFC.
            return Payload.Multipart.ContentType.applicationJSON.null
        }
    }
}
