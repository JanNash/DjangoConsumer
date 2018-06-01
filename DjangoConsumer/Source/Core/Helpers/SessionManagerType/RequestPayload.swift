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
public enum RequestPayload {
    case json(JSONDict)
    case multipart([FormData])
}


// MARK: -
public enum FormData {
    case json(JSONDict)
    case image(key: String, image: UIImage, mimeType: MimeType.Image)
    case nested([(String, RequestPayload)])
}


// MARK: -
public enum MimeType {
    public enum Application {
        case json
    }
    
    public enum Image {
        case jpeg
        case png
    }
}
