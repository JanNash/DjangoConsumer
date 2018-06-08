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
import Alamofire


// MARK: // Public
// MARK: -
public typealias MultipartDict = [String: (Data, MimeType)]


// MARK: -
public enum UnwrappedRequestPayload {
    case parameters(Parameters)
    case multipart(MultipartDict)
}


// MARK: -
public protocol KeyEncodingStrategy {
    func encodeNestedKey(outerKey: String?) -> (String) -> String
    func encodeIndexedKey(outerKey: String) -> (Int) -> String
}


// MARK: -
extension RequestPayload {
    func unwrap() -> UnwrappedRequestPayload {
        return self._unwrap()
    }
}


// MARK: -
public indirect enum RequestPayload: Equatable {
    case json(JSONDict)
    case multipart([FormData])
    case nested(String, [RequestPayload])
 
    public static var keyEncodingStrategy: KeyEncodingStrategy = DefaultKeyEncoding()
    
    public struct DefaultKeyEncoding: KeyEncodingStrategy {
        public func encodeIndexedKey(outerKey: String) -> (Int) -> String {
            return { outerKey + "[\($0)]" }
        }
        
        public func encodeNestedKey(outerKey: String?) -> (String) -> String {
            return { outerKey?.appending(".").appending($0) ?? $0 }
        }
    }
}


// MARK: - Array where Element == (String, RequestPayload)
extension Array where Element == (String, RequestPayload) {
    public static func == (_ lhs: [Element], _ rhs: [Element]) -> Bool {
        return self._equals(lhs, rhs)
    }
}


// MARK: -
public enum FormData: Equatable {
    case json(JSONDict)
    case image(key: String, image: UIImage, mimeType: MimeType.Image)
    case nested([(String, RequestPayload)])
    
    public static func == (lhs: FormData, rhs: FormData) -> Bool {
        return self._equals(lhs, rhs)
    }
}


// MARK: -
public enum MimeType: String {
    case applicationJSON = "application/json"
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    
    public enum Application: Equatable {
        case json
    }
    
    public enum Image: Equatable {
        case jpeg(compressionQuality: CGFloat)
        case png
    }
}


// MARK: // Private
private let jsonNullData: (Data, MimeType) = ("null".data(using: .utf8)!, .applicationJSON)

private func += <K, V>(_ lhs: inout Dictionary<K, V>, _ rhs: Dictionary<K, V>) {
    return lhs.merge(rhs, uniquingKeysWith: { _, r in r })
}


// MARK: -
private extension RequestPayload {
    func _unwrap() -> UnwrappedRequestPayload {
        var result: (Parameters, MultipartDict) = ([:], [:])
        self._merge(to: &result, outerKey: nil)
        return result.1.isEmpty ? .parameters(result.0) : .multipart(result.1)
    }
    
    func _merge(to parametersAndMultipart: inout (Parameters, MultipartDict), outerKey: String?) {
        switch self {
        case .json(let jsonDict):
            self._merge(jsonDict, to: &parametersAndMultipart.0, outerKey: outerKey)
            self._merge(jsonDict, to: &parametersAndMultipart.1, outerKey: outerKey)
        case .multipart(let formDataArray):
            formDataArray.forEach({
                self._mergeFormData($0, outerKey: outerKey, to: &parametersAndMultipart)
            })
        case .nested(let key, let payloads):
            let innerKey: String = RequestPayload.keyEncodingStrategy.encodeNestedKey(outerKey: outerKey)(key)
            payloads.forEach({
                $0._merge(to: &parametersAndMultipart, outerKey: innerKey)
            })
        }
    }
    
    func _mergeFormData(_ formData: FormData, outerKey: String?, to parametersAndMultipart: inout (Parameters, MultipartDict)) {
        switch formData {
        case .json(let jsonDict):
            self._merge(jsonDict, to: &parametersAndMultipart.0, outerKey: outerKey)
            self._merge(jsonDict, to: &parametersAndMultipart.1, outerKey: outerKey)
        case .image(let key, let image, let mimeType):
            let concatenateKeys: (String) -> String = RequestPayload.keyEncodingStrategy.encodeNestedKey(outerKey: outerKey)
            parametersAndMultipart.1[concatenateKeys(key)] = self._encodeImage(image, mimeType: mimeType)
        case .nested(let keyedPayloadArray):
            let concatenateKeys: (String) -> String = RequestPayload.keyEncodingStrategy.encodeNestedKey(outerKey: outerKey)
            keyedPayloadArray.forEach({
                $0.1._merge(to: &parametersAndMultipart, outerKey: concatenateKeys($0.0))
            })
        }
    }
    
    func _encodeImage(_ image: UIImage, mimeType: MimeType.Image) -> (Data, MimeType) {
        switch mimeType {
        case .jpeg(let compressionQuality):
            return (UIImageJPEGRepresentation(image, compressionQuality)!, .imageJPEG)
        case .png:
            return (UIImagePNGRepresentation(image)!, .imagePNG)
        }
    }
    
    func _merge(_ jsonDict: JSONDict, to parameters: inout Parameters, outerKey: String?) {
        if let outerKey: String = outerKey {
            parameters[outerKey] = jsonDict.unwrap()
        } else {
            parameters += jsonDict.unwrap()
        }
    }
    
    func _merge(_ jsonDict: JSONDict, to multipart: inout MultipartDict, outerKey: String?) {
        self._merge(
            jsonDict.dict.map({ $0 }),
            to: &multipart,
            outerKey: outerKey,
            concatenateKeys: RequestPayload.keyEncodingStrategy.encodeNestedKey
        )
    }
    
    func _merge(_ jsonArray: [JSONValue], to multipart: inout MultipartDict, outerKey: String) {
        self._merge(
            jsonArray.enumerated().map({ ($0.offset, $0.element) }),
            to: &multipart,
            outerKey: outerKey,
            concatenateKeys: RequestPayload.keyEncodingStrategy.encodeIndexedKey
        )
    }
    
    func _merge<Key, OuterKey>(_ array: [(Key, JSONValue)], to multipart: inout MultipartDict, outerKey: OuterKey, concatenateKeys: (OuterKey) -> (Key) -> String) {
        array.forEach({
            let innerKey: String = concatenateKeys(outerKey)($0.0)
            switch $0.1.typedValue {
            case .dict(let dict):
                if let dict: JSONDict = dict {
                    self._merge(dict, to: &multipart, outerKey: innerKey)
                } else {
                    multipart[innerKey] = jsonNullData
                }
            case .array(let array):
                if let array: [JSONValue] = array {
                    self._merge(array, to: &multipart, outerKey: innerKey)
                } else {
                    multipart[innerKey] = jsonNullData
                }
            default:
                multipart[innerKey] = ($0.1.toData(), .applicationJSON)
            }
        })
    }
}


// MARK: - Array where Element == (String, RequestPayload)
private extension Array where Element == (String, RequestPayload) {
    static func _equals(_ lhs: [Element], _ rhs: [Element]) -> Bool {
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
private extension FormData {
    static func _equals(_ lhs: FormData, _ rhs: FormData) -> Bool {
        switch (lhs, rhs) {
        case (.json(let l), .json(let r)):      return l == r
        case (.image(let l), .image(let r)):    return l == r
        case (.nested(let l), .nested(let r)):  return l == r
        default:                                return false
        }
    }
}
