//
//  League.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

struct League: Codable {
    let idLeague: String
    let strLeague: String
    let strSport: String
    let strLeagueAlternate: String?
}
