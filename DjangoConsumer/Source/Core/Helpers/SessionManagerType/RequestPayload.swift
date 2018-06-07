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
extension RequestPayload {
    public typealias UnwrappingStrategy = (RequestPayload)
    
    func unwrap() -> UnwrappedRequestPayload {
        return self._unwrap()
    }
}


// MARK: -
public indirect enum RequestPayload: Equatable {
    case json(JSONDict)
    case multipart([FormData])
    case nested(String, [RequestPayload])
}


// MARK: - Array where Element == (String, RequestPayload)
extension Array where Element == (String, RequestPayload) {
    public static func == (_ lhs: [Element], _ rhs: [Element]) -> Bool {
        return self._equals(lhs, rhs)
    }
}


// MARK: -
extension FormData {
    public func unwrap() -> [String: Data] {
        return self._unwrap()
    }
}


// MARK: -
//extension Collection where Element == FormData {
//    public func unwrap() -> [String: Data] {
//        return self.map({ $0.unwrap() })
//    }
//}


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
// MARK: -
private extension RequestPayload {
    func _unwrap() -> UnwrappedRequestPayload {
        func encodeIndexedKey(key: String, index: Int) -> String {
            return key + "[\(index)]"
        }
        
        func encodeNestedKeys(outerKey: String?, innerKey: String) -> String {
            guard let outerKey: String = outerKey else { return innerKey }
            return outerKey + "." + innerKey
        }
        
        func encodeImage(_ image: UIImage, mimeType: MimeType.Image) -> (Data, MimeType) {
            switch mimeType {
            case .jpeg(let compressionQuality):
                return (UIImageJPEGRepresentation(image, compressionQuality)!, .imageJPEG)
            case .png:
                return (UIImagePNGRepresentation(image)!, .imagePNG)
            }
        }
        
        let jsonNullData: Data = try! JSONSerialization.data(withJSONObject: NSNull())
        
        func convertJSONDictToMultipartDict(_ jsonDict: JSONDict?, prefixKey: String?) -> MultipartDict? {
            guard let jsonDict: JSONDict = jsonDict else { return nil }
            
            var result: MultipartDict = [:]
            jsonDict.dict.forEach({ key, value in
                let innerPrefixKey: String = encodeNestedKeys(outerKey: prefixKey, innerKey: key)
                
                switch value.typedValue {
                case .dict(let dict):
                    if let innerDict: MultipartDict = convertJSONDictToMultipartDict(dict, prefixKey: innerPrefixKey) {
                        result.merge(innerDict, uniquingKeysWith: { _, r in r })
                    } else {
                        result[innerPrefixKey] = (jsonNullData, .applicationJSON)
                    }
                case .array(let array):
                    if let innerDict: MultipartDict = convertJSONArrayToMultipartDict(array, prefixKey: innerPrefixKey) {
                        result.merge(innerDict, uniquingKeysWith: { _, r in r })
                    } else {
                        result[innerPrefixKey] = (jsonNullData, .applicationJSON)
                    }
                default:
                    result[innerPrefixKey] = (value.toData(), .applicationJSON)
                }
            })
            return result
        }
        
        func convertJSONArrayToMultipartDict(_ jsonArray: [JSONValue]?, prefixKey: String) -> MultipartDict? {
            return jsonArray?
                .map({ $0.toData() })
                .enumerated()
                .mapToDict({ (encodeIndexedKey(key: prefixKey, index: $0.offset), ($0.element, .applicationJSON)) })
        }
        
        var resultParameters: Parameters = [:]
        var resultMultipart: MultipartDict = [:]
        
        func mergeParameters(_ parameters: Parameters) {
            resultParameters.merge(parameters, uniquingKeysWith: { _, r in r })
        }
        
        func mergeMultipart(_ multipartDict: MultipartDict) {
            resultMultipart.merge(multipartDict, uniquingKeysWith: { _, r in r })
        }
        
        func _unwrap(_ requestPayload: RequestPayload) -> UnwrappedRequestPayload {
            switch requestPayload {
            case .json(let jsonDict):
                return .parameters(jsonDict.unwrap())
            case .multipart(let formDataArray):
                formDataArray.forEach({
                    switch $0 {
                    case .json(let jsonDict):
                        mergeParameters(jsonDict.unwrap())
                        if let dict: MultipartDict = convertJSONDictToMultipartDict(jsonDict, prefixKey: nil) {
                            mergeMultipart(dict)
                        }
                    case .image(let key, let image, let mimeType):
                        resultMultipart[key] = encodeImage(image, mimeType: mimeType)
                    case .nested(let keyedPayloadArray):
                        keyedPayloadArray.forEach({
                            switch $0.1 {
                            case .
                                resultParameters[$0.0] = value.unwrap()
                            case .multipart(let value):
                                resultMultipart[$0.0] =
                            }
                        })
                        break
                    }
                })
            case .nested(_, _/*let key, let payload*/):
                break
            }
        }
        
        return resultMultipart.isEmpty ? .parameters(resultParameters) : .multipart(resultMultipart)
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
    
    func _unwrap() -> [String: Data] {
//        switch formData {
//        case .json(let value):
//            result.merge(value.unwrap(), uniquingKeysWith: { _, r in r })
//        case .image(key: let key, image: let image, mimeType: let mimeType):
//            result[key] = {
//                switch mimeType {
//                case .jpeg(let compressionQuality):
//                    return UIImageJPEGRepresentation(image, compressionQuality)
//                case .png:
//                    return UIImagePNGRepresentation(image)
//                }
//            }()
//        case .nested(let value):
//            result.merge(value.mapToDict({ parsePayload($0) }), uniquingKeysWith: { _, r in r})
//        }
        return [:]
    }
    
    //    public func parseMultipart(_ formData: [FormData]) -> Parameters {
    //        var result: Parameters = [:]
    //        for fd in formData {
    //            switch fd {
    //            case .json(let value):
    //                result.merge(value.unwrap(), uniquingKeysWith: { _, r in r })
    //            case .image(key: let key, image: let image, mimeType: let mimeType):
    //                result[key] = {
    //                    switch mimeType {
    //                    case .jpeg(let compressionQuality):
    //                        return UIImageJPEGRepresentation(image, compressionQuality)
    //                    case .png:
    //                        return UIImagePNGRepresentation(image)
    //                    }
    //                }()
    //            case .nested(let value):
    //                result.merge(value.mapToDict({ parsePayload($0) }), uniquingKeysWith: { _, r in r})
    //            }
    //        }
    //        return result
    //    }
}
