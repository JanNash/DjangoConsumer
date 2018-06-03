//
//  RequestPayload.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 30.05.18.
//  Copyright © 2018 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//

import Foundation


// MARK: // Public
// MARK: -
public enum RequestPayload: Equatable {
    case json(JSONDict)
    case multipart([FormData])
}


//extension Array: RequestPayloadConvertible where Element: RequestPayloadConvertible {
//    public func toPayload(for method: ResourceHTTPMethod) -> RequestPayload {
//        let payloads: [RequestPayload] = self.map({ $0.toPayload(for: method) })
//        if payloads.contains(.multipart) {
//
//        }
//    }
//}


// MARK: - Array where Element == (String, RequestPayload)
extension Array where Element == (String, RequestPayload) {
    public static func == (lhs: [Element], rhs: [Element]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (i, lElement) in lhs.enumerated() {
            guard lElement == rhs[i] else {
                return false
            }
        }
        return true
    }
}


// MARK: -
public enum FormData: Equatable {
    case json(JSONDict)
    case image(key: String, image: UIImage, mimeType: MimeType.Image)
    case nested([(String, RequestPayload)])
    
    public static func == (lhs: FormData, rhs: FormData) -> Bool {
        switch (lhs, rhs) {
        case (.json(let l), .json(let r)):      return l == r
        case (.image(let l), .image(let r)):    return l == r
        case (.nested(let l), .nested(let r)):  return l == r
        default:                                return false
        }
    }
}


// MARK: -
public enum MimeType {
    public enum Application: Equatable {
        case json
    }
    
    public enum Image: Equatable {
        case jpeg
        case png
    }
}
