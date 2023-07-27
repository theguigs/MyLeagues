//
//  LeagueService.swift
//  Engine
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

class LeagueService: AsyncCacheHandling {
    
    let networkClient: NetworkClient
    let fileDataStore: FileDataStore
    
    init(networkClient: NetworkClient, fileDataStore: FileDataStore) {
        self.networkClient = networkClient
        self.fileDataStore = fileDataStore
    }
    
//    public func readCitiesFromCache(completion: @escaping (Bool) -> Void) {
//        readFromCacheAsync(
//            filename: Self.citiesFilename,
//            directory: fileDataStore.rootDirectory()
//        ) { [weak self] (cities: [GeocodedCity]?) in
//            guard let self, let cities else {
//                WLOG("[CitiesService] No cities cached data")
//                completion(false)
//                return
//            }
//
//            ILOG("[CitiesService] cities read from cache")
//            self.cities = cities
//
//            completion(true)
//        }
//    }
        
    /// Fetch all leagues in database
    ///
    /// - Parameters:
    ///     - query: String query from TextField
    ///
    /// - Returns:
    ///     - completion: Give a callback to handle WS response
    ///                Return tuple of 2 params ([League] & Error) both optionals
    public func fetchAllLeagues(completion: @escaping ([League]?, APIError?) -> Void) {
        networkClient.call(
            endpoint: LeagueEndpoints.allLeagues
        ) { result in
            switch result {
                case .success((let data, _)):
                    do {
                        let allLeaguesResponse = try JSONDecoder.snakeDecoder.decode(AllLeaguesResponse.self, from: data)
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
}
