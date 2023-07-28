//
//  Endpoint.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

protocol Endpoint {
    var verb: HTTPVerb { get }
    var path: String { get }
}

enum HTTPVerb: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
