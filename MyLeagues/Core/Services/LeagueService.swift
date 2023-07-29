//
//  LeagueService.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public class LeagueService: AsyncExpirableCacheHandling {
    static let leaguesFilename = "LeagueService.leagues"

    let networkClient: NetworkClient
    let expirableDataStore: ExpirableFileDataStore

    init(networkClient: NetworkClient, expirableDataStore: ExpirableFileDataStore) {
        self.networkClient = networkClient
        self.expirableDataStore = expirableDataStore
    }
            
    /// Fetch all leagues first from cache, if not exists call the network to fetch all leagues
    ///
    /// - Parameters:
    ///     - None
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Return Result type with needed data or error
    public func fetchAllLeaguesIfNeeded(completion: @escaping (Result<[League], APIError>) -> Void) {
        readFromCacheAsync(
            filename: Self.leaguesFilename,
            directory: expirableDataStore.dataStore.rootDirectory(),
            maxValidity: .hours(1)
        ) { [weak self] (leagues: [League]?) in
            guard let leagues else {
                WLOG("[LeagueService] No leagues cached data")
                self?.fetchAllLeagues(completion: completion)
                return
            }
            
            ILOG("[LeagueService] leagues read from cache")
            completion(.success(leagues))
        }
    }
    
    /// Fetch all leagues in database
    ///
    /// - Parameters:
    ///     - None
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Return Result type with needed data or error
    public func fetchAllLeagues(completion: @escaping (Result<[League], APIError>) -> Void) {
        ILOG("[LeagueService] Fetching all leagues")
        
        networkClient.call(
            endpoint: LeagueEndpoints.allLeagues
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success((let data, _)):
                do {
                    let allLeaguesResponse = try JSONDecoder.snakeDecoder.decode(AllLeaguesResponse.self, from: data)
                    self.persistLeagues(allLeaguesResponse.leagues)
                    
                    completion(.success(allLeaguesResponse.leagues))
                } catch let error {
                    ELOG("[LeagueService] fetchAllLeagues error : \(error)")
                    let apiError = APIError.unexpectedAPIResponse
                    completion(.failure(apiError))
                }
            case .failure(let error):
                ELOG("[LeagueService] fetchAllLeagues error : \(error)")
                let apiError = APIError.requestFailure
                completion(.failure(apiError))
            }
        }
    }
    
    private func persistLeagues(_ leagues: [League]) {
        ILOG("[LeagueService] Persisting leagues")
        
        persistAsync(
            object: leagues,
            filename: Self.leaguesFilename,
            directory: expirableDataStore.dataStore.rootDirectory()
        )
    }
}
