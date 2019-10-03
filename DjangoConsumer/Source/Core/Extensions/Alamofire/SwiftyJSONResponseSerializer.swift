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
// Before being refactored, this code was copied
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
    
    // Private Static Constants
    private static let _emptyStatusCodes: [Int] = [204, 205]
    
    // DataResponseSerializerProtocol Conformance
    public private(set) var serializeResponse: Serialization
}
 

// MARK: // Private
// MARK: Serialization Closure Creation
private extension SwiftyJSONResponseSerializer {
    static func _createResponseSerializerClosure(options: ReadingOptions) -> Serialization {
        return {
            if let error: Error = $3 {
                return .failure(error)
            }

            if let response = $1, self._emptyStatusCodes.contains(response.statusCode) {
                return .success(JSON.null)
            }
            
            func _failure(reason: AFError.ResponseSerializationFailureReason) -> Result<JSON> {
                return .failure(AFError.responseSerializationFailed(reason: reason))
            }
            
            guard let validData: Data = $2, validData.count > 0 else {
                return _failure(reason: .inputDataNilOrZeroLength)
            }

            do {
                return .success(JSON(try JSONSerialization.jsonObject(with: validData, options: options)))
            } catch let serializationError {
                return _failure(reason: .jsonSerializationFailed(error: serializationError))
            }
        }
    }
}



// The aforementioned full license text:
/*
The MIT License (MIT)

Copyright (c) 2014 SwiftyJSON

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
