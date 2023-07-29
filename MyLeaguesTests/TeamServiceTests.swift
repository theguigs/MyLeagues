//
//  TeamServiceTests.swift
//  MyLeaguesTests
//
//  Created by Guillaume Audinet on 29/07/2023.
//

import XCTest
import MyLeagues

final class TeamServiceTests: XCTestCase {

    var engine: Engine?
    
    override func setUpWithError() throws {
        guard let stringURL = Bundle.main.object(forInfoDictionaryKey: "base_url") as? String,
              let baseURL = URL(string: stringURL) else {
            XCTFail("Base URL is not a valid URL")
            return
        }

        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        self.engine = Engine(configuration: configuration)
    }
    
    func testFetchingTeams() throws {
        XCTAssertNotNil(engine)
        
        let didFetchLeaguesExpectation = self.expectation(description: "Did fetch teams")

        let league = League(strLeague: "French Ligue 1")
        self.engine?.teamService.fetchAllTeams(for: league) { teams, error in
            XCTAssertNil(error)
            XCTAssertNotNil(teams)
            XCTAssertTrue((teams ?? []).count > 0)
            didFetchLeaguesExpectation.fulfill()
        }
        
        wait(for: [didFetchLeaguesExpectation], timeout: 1)
    }
    
    func testPerformanceAPI() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let league = League(strLeague: "French Ligue 1")
            self.engine?.teamService.fetchAllTeams(for: league) { teams, error in
                return
            }
        }
    }
}
