//
//  TeamEndpoints.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

enum TeamEndpoints: Endpoint {
    case teams

    var verb: HTTPVerb {
        switch self {
        case .teams:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .teams:
            return "/search_all_teams.php"
        }
    }
}
