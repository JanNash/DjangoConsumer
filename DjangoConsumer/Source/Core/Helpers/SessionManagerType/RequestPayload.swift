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
public typealias MultipartValue = (String, (Data, Multipart.ContentType))

// MARK: -
public typealias MultipartPayload = [String: (Data, Multipart.ContentType)]

// MARK: -
public protocol MultipartConversion {
    typealias Convertible = MultipartValueConvertible
    typealias ContentType = Multipart.ContentType
    
    func concatenate(outerKey: String?, innerKey: String/*, for value: Convertible, with contentType: ContentType*/) -> String
    func concatenate(outerKey: String, index: Int/*, for value: Convertible, with contentType: ContentType*/) -> String
    func merge(_ convertible: MultipartValueConvertible, key: String, to payload: inout MultipartPayload)
    func mergeNull(with contentType: ContentType, to payload: inout MultipartPayload, key: String)
}


public extension MultipartConversion {
    public func concatenate(outerKey: String?, innerKey: String/*, for value: Convertible, with contentType: ContentType*/) -> String {
        return outerKey?.appending(innerKey) ?? innerKey
    }
    
    public func concatenate(outerKey: String, index: Int/*, for value: Convertible, with contentType: ContentType*/) -> String {
        return outerKey + "[\(index)]"
    }
    
    public func merge(_ convertible: MultipartValueConvertible, key: String, to payload: inout MultipartPayload) {
        convertible.merge(to: &payload, key: key, encoding: self)
    }
    
    func mergeNull(with contentType: ContentType, to payload: inout MultipartPayload, key: String) {
        payload[key] = contentType.null
    }
}


// MARK: -
public enum _RequestPayload {
    case parameters(Parameters)
    case multipart(MultipartPayload)
}


public enum Multipart {
    public enum ContentType: String {
        case applicationJSON = "application/json"
        case imageJPEG = "image/jpeg"
        case imagePNG = "image/png"
        
        public var null: (Data, ContentType) {
            return ("null".data(using: .utf8)!, self)
        }
    }
}


public protocol MultipartPayloadConvertible: MultipartValueConvertible {
    func encode(key: String?, encoding: MultipartConversion) -> MultipartPayload
}


public extension MultipartPayloadConvertible {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartConversion) {
        payload += self.encode(key: key, encoding: encoding)
    }
}


public protocol MultipartValueConvertible {
    func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartConversion)
}


extension JSONDict: MultipartPayloadConvertible {
    public func encode(key: String?, encoding: MultipartConversion) -> MultipartPayload {
        var result: MultipartPayload = [:]
        self.dict.forEach({
            $0.value.merge(
                to: &result,
                key: encoding.concatenate(outerKey: key, innerKey: $0.key),
                encoding: encoding
            )
        })
        return result
    }
}


extension Array: MultipartValueConvertible where Element == JSONValue {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartConversion) {
        self.enumerated().forEach({
            $0.element.merge(
                to: &payload,
                key: encoding.concatenate(outerKey: key, index: $0.offset),
                encoding: encoding
            )
        })
    }
}


extension JSONValue: MultipartValueConvertible {
    public func merge(to payload: inout MultipartPayload, key: String, encoding: MultipartConversion) {
        let mergeNull: (inout MultipartPayload) -> Void = { encoding.mergeNull(with: .applicationJSON, to: &$0, key: key) }
        
        switch self.typedValue {
        case .dict(let dict):
            dict?.merge(to: &payload, key: key, encoding: encoding) ?? mergeNull(&payload)
        case .array(let array):
            array?.merge(to: &payload, key: key, encoding: encoding) ?? mergeNull(&payload)
        default:
            let value: Any = JSONValue.unwrap(self)
            guard !(value is NSNull), let data: Data = "\(value)".data(using: .utf8) else {
                mergeNull(&payload)
                return
            }
            payload[key] = (data, .applicationJSON)
        }
    }
}





























public typealias MultipartDict = [String: (Data, MimeType)]

public enum MutlipartContentType: String {
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
                self._merge($0, to: &parametersAndMultipart, outerKey: outerKey)
            })
        case .nested(let key, let payloads):
            let innerKey: String = RequestPayload.keyEncodingStrategy.encodeNestedKey(outerKey: outerKey)(key)
            payloads.forEach({
                $0._merge(to: &parametersAndMultipart, outerKey: innerKey)
            })
        }
    }
    
    func _merge(_ formData: FormData, to parametersAndMultipart: inout (Parameters, MultipartDict), outerKey: String?) {
        switch formData {
        case .json(let jsonDict):
            self._merge(jsonDict, to: &parametersAndMultipart.0, outerKey: outerKey)
            self._merge(jsonDict, to: &parametersAndMultipart.1, outerKey: outerKey)
        case .image(let key, let image, let mimeType):
            let key: String = RequestPayload.keyEncodingStrategy.encodeNestedKey(outerKey: outerKey)(key)
            parametersAndMultipart.1[key] = self._encodeImage(image, mimeType: mimeType)
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
        func _setNull(_ innerKey: String) -> Void { multipart[innerKey] = jsonNullData }
        array.forEach({
            let innerKey: String = concatenateKeys(outerKey)($0.0)
            switch $0.1.typedValue {
            case .null, .bool, .int, .uInt, .float, .string:
                multipart[innerKey] = ($0.1.toData(), .applicationJSON)
            case .dict(let dict):
                guard let dict: JSONDict = dict else { _setNull(innerKey); break }
                self._merge(dict, to: &multipart, outerKey: innerKey)
            case .array(let array):
                guard let array: [JSONValue] = array else { _setNull(innerKey); break }
                self._merge(array, to: &multipart, outerKey: innerKey)
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
