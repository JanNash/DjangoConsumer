//
//  UIImage (MultipartValueConvertible).swift
//  DjangoConsumer
//
//  Created by Jan Nash on 18.07.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import UIKit


// MARK: // Public
extension UIImage: MultipartValueConvertible {
    public func toMultipartValue() -> Payload.Multipart.Value? {
        return Payload.Multipart.value(UIImagePNGRepresentation(self), .imagePNG)
    }
}
