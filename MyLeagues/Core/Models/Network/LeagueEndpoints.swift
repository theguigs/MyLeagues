//
//  LeagueEndpoints.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

enum LeagueEndpoints: Endpoint {
    case allLeagues

    var verb: HTTPVerb {
        switch self {
        case .allLeagues:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .allLeagues:
            return "/all_leagues.php"
        }
    }
}
