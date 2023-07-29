//
//  LeagueSearchViewModel.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

class LeagueSearchViewModel {
    let engine: Engine
    
    var leagues: [League] = []
    var filteredLeagues: [League] = []

    var error: APIError?
    
    private let debouncer = Debouncer()

    init(engine: Engine) {
        self.engine = engine
    }
    
    func fetchAllLeagues(completion: @escaping () -> Void) {
        engine.leagueService.fetchAllLeaguesIfNeeded { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let leagues):
                self.leagues = leagues
                self.filteredLeagues = leagues
            case .failure(let error):
                self.error = error
            }
            
            completion()
        }
    }
    
    func searchLeagues(from query: String, completion: @escaping () -> Void) {
        guard !query.isEmpty else {
            self.filteredLeagues = leagues
            completion()
            
            return
        }
        
        debouncer.debounce { [weak self] in
            guard let self else { return }

            self.filteredLeagues = leagues.filter { $0.strLeague.contains(query) }
            completion()
        }
    }
}
