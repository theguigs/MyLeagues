//
//  URLRequest+Extensions.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

extension URLRequest {
    /// Small aggregator to have a curl string
    public var curlString: String {
        var result = "curl -k "
        
        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }
        
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }
        
        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }
        
        if let url = url {
            result += url.absoluteString
        }
        
        return result
    }
}
