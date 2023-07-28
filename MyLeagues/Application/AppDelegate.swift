//
//  AppDelegate.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 27/07/2023.
//

import UIKit

// TODO :
// - Unit Tests
// - Add Cache into Services
// - Clean fichiers non utilisés / Vérifier naming fichiers

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var engine: Engine?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let stringURL = Bundle.main.object(forInfoDictionaryKey: "base_url") as? String,
              let baseURL = URL(string: stringURL) else {
            fatalError("Base URL is not a valid URL")
        }

        window = UIWindow()

        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        let engine = Engine(configuration: configuration)
        self.engine = engine

        let rootViewController = LeagueSearchViewController(engine: engine)
        let navController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}
