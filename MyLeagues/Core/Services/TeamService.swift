//
//  TeamService.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public class TeamService: AsyncCacheHandling {
    
    let networkClient: NetworkClient
    let fileDataStore: FileDataStore
    
    init(networkClient: NetworkClient, fileDataStore: FileDataStore) {
        self.networkClient = networkClient
        self.fileDataStore = fileDataStore
    }

    /// Fetch all leagues in database
    ///
    /// - Parameters:
    ///     - league: League object
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Return tuple of 2 params ([Team] & Error) both optionals
    public func fetchAllTeams(
        for league: League,
        completion: @escaping ([Team]?, APIError?) -> Void
    ) {
        let dict = [
            "l": league.strLeague
        ]
        
        networkClient.call(
            endpoint: TeamEndpoints.teams,
            dict: dict,
            parameterEncoding: .URL
        ) { result in
            switch result {
                case .success((let data, _)):
                    do {
                        let teamsResponse = try JSONDecoder.snakeDecoder.decode(TeamsResponse.self, from: data)
                        completion(teamsResponse.teams, nil)
                    } catch let error {
                        ELOG("[LeagueService] fetchAllLeagues error : \(error)")
                        let apiError = APIError.unexpectedAPIResponse
                        completion(nil, apiError)
                    }
                case .failure(let error):
                    ELOG("[LeagueService] fetchAllLeagues error : \(error)")
                    let apiError = APIError.requestFailure
                    completion(nil, apiError)
            }
        }
    }

}
