//
//  Engine.swift
//  Engine
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
        
        self.leagueService = LeagueService(networkClient: networkClient, fileDataStore: fileDataStore)
        self.teamService = TeamService(networkClient: networkClient, fileDataStore: fileDataStore)
    }
}
