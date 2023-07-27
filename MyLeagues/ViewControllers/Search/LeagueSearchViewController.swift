//
//  LeagueSearchViewController.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit

class LeagueSearchViewController: EnginedViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private property
    private lazy var leagueSearchViewModel = LeagueSearchViewModel(engine: engine)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Search"
            
        configureTextField()
        configureTableView()
        
        fetchAllLeagues()
    }
    
    private func fetchAllLeagues() {
        leagueSearchViewModel.fetchAllLeagues() { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
        }
    }
    
    private func configureTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidEditingChanged), for: .editingChanged)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LeagueSearchViewController: UITextFieldDelegate {
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {
        let query = textField.text ?? ""
        
        leagueSearchViewModel.searchLeagues(from: query) { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LeagueSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueSearchViewModel.filteredLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        var content = cell.defaultContentConfiguration()

        let league = leagueSearchViewModel.filteredLeagues[indexPath.row]
        content.text = league.strLeague
        content.secondaryText = league.strSport
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let league = leagueSearchViewModel.filteredLeagues[indexPath.row]
        
        let leagueViewController = LeagueViewController(engine: engine, league: league)
        navigationController?.pushViewController(leagueViewController, animated: true)
    }
}
