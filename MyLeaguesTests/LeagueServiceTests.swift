//
//  LeagueServiceTests.swift
//  MyLeaguesTests
//
//  Created by Guillaume Audinet on 29/07/2023.
//

import XCTest
import MyLeagues

final class LeagueServiceTests: XCTestCase {

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
    
    func testFetchingLeagues() throws {
        XCTAssertNotNil(engine)
        
        let didFetchLeaguesExpectation = self.expectation(description: "Did fetch all leagues")

        self.engine?.leagueService.fetchAllLeaguesIfNeeded { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
                XCTAssertTrue((leagues).count > 0)
            case .failure(_):
                break
            }
            
            didFetchLeaguesExpectation.fulfill()
        }
        
        
        wait(for: [didFetchLeaguesExpectation], timeout: 1)
    }
    
    func testPerformanceAPI() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.engine?.leagueService.fetchAllLeagues(completion: { result in
                return
            })
        }
    }
}
