//
//  URL.swift
//  Riposo
//
//  Copyright © 2018 Dot First. All rights reserved.
//

import Foundation

public extension URL {
    public static func stringFromParameters(parameters: [String: Any]) -> String {
        var parameterArray = [String]()
        for (key, value) in parameters {
            if let values = value as? [Any] {
                for eachValue in values {
                    parameterArray.append("\(key.replacingOccurrences(of: "[]", with: "").appending("[]"))=\(eachValue)")
                }
            } else {
                parameterArray.append("\(key)=\(value)")
            }
        }
        
        return parameterArray.joined(separator: "&")
    }
    
    public static func parametersFromString(string: String) -> [String: Any] {
        var parsed = [String: Any]()
        let parameters = string.components(separatedBy: "&")
        for parameter in parameters {
            let parameterPieces = parameter.components(separatedBy: "=")
            var parameterKey = parameterPieces[0].replacingOccurrences(of: "%5B%5D", with: "").replacingOccurrences(of: "[]", with: "")
            
            if let existingParameter = parsed[parameterKey] {
                if let existingParameterArray = existingParameter as? [Any] {
                    var newParameterArray: [Any] = [parameterPieces[1]]
                    newParameterArray.append(contentsOf: existingParameterArray)
                    parsed[parameterKey] = newParameterArray
                } else {
                    parsed[parameterKey] = [existingParameter, parameterPieces[1]]
                }
            } else {
                parsed[parameterKey] = parameterPieces[1]
            }
        }
        return parsed
    }
    
    public func appendingQueryParameters(parameters: [String: Any]) -> URL {
        if (parameters.count == 0) {
            return self
        }
        
        return URL(string: "\(absoluteString.split(separator: "?")[0])?\(URL.stringFromParameters(parameters: queryParameters.merging(parameters) { (_, new) in new }))")!
    }
    
    mutating public func appendQueryParameters(parameters: [String: Any]) {
        self = appendingQueryParameters(parameters: parameters)
    }
    
    public var queryParameters: [String: Any] {
        get {
            guard let query = query else { return [String: String]() }
            return URL.parametersFromString(string: query)
        }
    }
}
