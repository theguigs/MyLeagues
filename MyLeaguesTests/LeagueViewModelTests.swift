//
//  LeagueViewModelTests.swift
//  MyLeaguesTests
//
//  Created by Guillaume Audinet on 29/07/2023.
//

import XCTest
import MyLeagues

final class LeagueViewModelTests: XCTestCase {

    var leagueViewModel: LeagueViewModel?
    var teams: [Team] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.\
        guard let stringURL = Bundle.main.object(forInfoDictionaryKey: "base_url") as? String,
              let baseURL = URL(string: stringURL) else {
            XCTFail("Base URL is not a valid URL")
            return
        }

        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        let engine = Engine(configuration: configuration)
        self.leagueViewModel = LeagueViewModel(engine: engine)
        
        for i in 0 ..< 10 {
            let team = Team(strTeam: "Team \(i)")
            teams.append(team)
        }
    }

    func testSortingTeams() throws {
        XCTAssertNotNil(leagueViewModel)
        XCTAssertFalse(teams.isEmpty)
        
        let sortedTeams = leagueViewModel?.sortTeamsByAntiAlphabeticalOrder(teams)
        let first = try XCTUnwrap(sortedTeams?.first)
        
        XCTAssertEqual(first.strTeam, "Team 9")
    }
    
    func testRemovingUnevenTeams() throws {
        XCTAssertNotNil(leagueViewModel)
        XCTAssertFalse(teams.isEmpty)
        
        XCTAssertEqual(teams.count, 10)

        let computedTeams = leagueViewModel?.removeUnevenTeams(teams)
        
        XCTAssertEqual(computedTeams?.count, 5)
    }
}
