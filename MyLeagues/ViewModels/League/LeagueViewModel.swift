//
//  LeagueViewModel.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public class LeagueViewModel {
    let engine: Engine
    
    var teams: [Team] = []
    
    public init(engine: Engine) {
        self.engine = engine
    }
    
    func fetchAllTeams(for league: League, completion: @escaping () -> Void) {
        engine.teamService.fetchAllTeams(for: league) { [weak self] teams, error in
            guard let self else { return }
            guard error == nil else {
                // Manage error
                return
            }
            
            let sortedTeams = sortTeamsByAntiAlphabeticalOrder(teams)
            let computedTeams = removeUnevenTeams(sortedTeams)
            self.teams = computedTeams
            
            completion()
        }
    }
    
    public func sortTeamsByAntiAlphabeticalOrder(_ teams: [Team]?) -> [Team] {
        guard let teams else { return [] }
        return teams.sorted { $0.strTeam > $1.strTeam }
    }

    public func removeUnevenTeams(_ teams: [Team]?) -> [Team] {
        guard let teams else { return [] }
        return teams
            .enumerated()
            .filter { $0.offset % 2 == 0 }
            .compactMap { $0.element }
    }

}
