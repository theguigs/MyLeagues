//
//  MyLeaguesConfiguration.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public struct EngineConfiguration {
    let network: Network

    public init(network: Network) {
        self.network = network
    }
}

extension EngineConfiguration {
    public struct Network {
        let baseUrl: URL

        public init(baseUrl: URL) {
            self.baseUrl = baseUrl
        }
    }
}
