//
//  Team.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public struct Team: Codable {
    public let idTeam: String
    public let strTeam: String
    public let strSport: String
    public let strLeague: String
    public let strTeamBadge: String
    
    // Init used for testing purposes
    public init(
        idTeam: String = UUID().uuidString,
        strTeam: String,
        strSport: String = "",
        strLeague: String = "",
        strTeamBadge: String = ""
    ) {
        self.idTeam = idTeam
        self.strTeam = strTeam
        self.strSport = strSport
        self.strLeague = strLeague
        self.strTeamBadge = strTeamBadge
    }
}
