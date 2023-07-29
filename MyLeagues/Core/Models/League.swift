//
//  League.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public struct League: Codable {
    public let idLeague: String
    public let strLeague: String
    public let strSport: String
    public let strLeagueAlternate: String?
    
    // Init used for testing purposes
    public init(
        idLeague: String = UUID().uuidString,
        strLeague: String,
        strSport: String = "",
        strLeagueAlternate: String? = nil
    ) {
        self.idLeague = idLeague
        self.strLeague = strLeague
        self.strSport = strSport
        self.strLeagueAlternate = strLeagueAlternate
    }
}
