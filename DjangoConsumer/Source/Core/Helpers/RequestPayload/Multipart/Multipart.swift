//
//  Multipart.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 09.06.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: - MultipartValue
public typealias MultipartValue = (String, (Data, Multipart.ContentType))


// MARK: - MultipartPayload
public typealias MultipartPayload = [String: (Data, Multipart.ContentType)]


// MARK: -
public enum Multipart {
    public enum ContentType: String, CustomStringConvertible {
        case applicationJSON = "application/json"
        case imageJPEG = "image/jpeg"
        case imagePNG = "image/png"
        
        public var null: (Data, ContentType) {
            return ("null".data(using: .utf8)!, self)
        }
        
        public var description: String {
            return "Multipart.ContentType(\(self.rawValue))"
        }
    }
}
