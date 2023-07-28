//
//  MyLeagues.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

class Engine {
    private let networkClient: NetworkClient

    var leagueService: LeagueService
    var teamService: TeamService

    init(
        configuration: EngineConfiguration
    ) {
        self.networkClient = NetworkClient(configuration: configuration)
        
        let fileDataStore = FileDataStore()
        let expirableDataStore = ExpirableFileDataStore(dataStore: fileDataStore)

        self.leagueService = LeagueService(networkClient: networkClient, expirableDataStore: expirableDataStore)
        self.teamService = TeamService(networkClient: networkClient, fileDataStore: fileDataStore)
    }
}
