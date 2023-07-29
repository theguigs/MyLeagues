//
//  MyLeagues.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public class Engine {
    private let networkClient: NetworkClient

    public var leagueService: LeagueService
    public var teamService: TeamService

    public init(
        configuration: EngineConfiguration
    ) {
        self.networkClient = NetworkClient(configuration: configuration)
        
        let fileDataStore = FileDataStore()
        let expirableDataStore = ExpirableFileDataStore(dataStore: fileDataStore)

        self.leagueService = LeagueService(networkClient: networkClient, expirableDataStore: expirableDataStore)
        self.teamService = TeamService(networkClient: networkClient, fileDataStore: fileDataStore)
    }
}
