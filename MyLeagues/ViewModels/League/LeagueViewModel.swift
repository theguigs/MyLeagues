//
//  LeagueViewModel.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

class LeagueViewModel {
    let engine: Engine
    
    var teams: [Team] = []
    
    init(engine: Engine) {
        self.engine = engine
    }
    
    func fetchAllTeams(for league: League, completion: @escaping () -> Void) {
        engine.teamService.fetchAllTeams(for: league) { [weak self] teams, error in
            guard let self else { return }
            guard error == nil else {
                // Manage error
                return
            }
            
            self.teams = teams ?? []
            
            completion()
        }
    }

}
