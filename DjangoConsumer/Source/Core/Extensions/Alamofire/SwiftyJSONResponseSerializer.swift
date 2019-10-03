//
//  SwiftyJSONResponseSerializer.swift
//  DjangoConsumer
//
//  Created by Jan Nash on 04.10.19.
//  Copyright © 2019 Jan Nash. All rights reserved.
//  Published under the BSD-3-Clause license.
//  Full license text can be found in the LICENSE file
//  at the root of this repository.
//
// Before being refactored, some of this code was copied
// from hash: 64b4c1e710555061e50aad02e8795542fd0a5df5
// of fork: https://www.github.com/JanNash/Alamofire-SwiftyJSON
// of original repository: https://github.com/SwiftyJSON/Alamofire-SwiftyJSON
// The full license text as supplied in the LICENSE file (same commit hash)
// can be found at the bottom of this file.

import Alamofire
import SwiftyJSON


// MARK: // Public
// MARK: Struct Declaration
public struct SwiftyJSONResponseSerializer: DataResponseSerializerProtocol {
    // Nested Types
    public typealias ReadingOptions = JSONSerialization.ReadingOptions
    public typealias Serialization = (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<JSON>
    
    // Init
    public init(options: ReadingOptions = .allowFragments) {
        self.serializeResponse = Self._createResponseSerializerClosure(options: options)
    }
    
    // DataResponseSerializerProtocol Conformance
    public private(set) var serializeResponse: Serialization
}
 

// MARK: // Private
// MARK: Serialization Closure Creation
private extension SwiftyJSONResponseSerializer {
    static func _createResponseSerializerClosure(options: ReadingOptions) -> Serialization {
        return {
            _, response, data, error in
            guard error == nil else { return .failure(error!) }

            if let response = response, [204, 205].contains(response.statusCode) { return .success(JSON.null) }

            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }

            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: options)
                return .success(JSON(json))
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
}
