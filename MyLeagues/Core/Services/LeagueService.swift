//
//  LeagueService.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

class LeagueService: AsyncExpirableCacheHandling {
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
    ///                Return tuple of 2 params ([League] & Error) both optionals
    public func fetchAllLeaguesIfNeeded(completion: @escaping ([League]?, APIError?) -> Void) {
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
            completion(leagues, nil)
        }
    }
    
    /// Fetch all leagues in database
    ///
    /// - Parameters:
    ///     - None
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Return tuple of 2 params ([League] & Error) both optionals
    private func fetchAllLeagues(completion: @escaping ([League]?, APIError?) -> Void) {
        networkClient.call(
            endpoint: LeagueEndpoints.allLeagues
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success((let data, _)):
                    do {
                        let allLeaguesResponse = try JSONDecoder.snakeDecoder.decode(AllLeaguesResponse.self, from: data)
                        self.persistLeagues(allLeaguesResponse.leagues)
                        
                        completion(allLeaguesResponse.leagues, nil)
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
    
    private func persistLeagues(_ leagues: [League]) {
        persistAsync(
            object: leagues,
            filename: Self.leaguesFilename,
            directory: expirableDataStore.dataStore.rootDirectory()
        )
    }
}
