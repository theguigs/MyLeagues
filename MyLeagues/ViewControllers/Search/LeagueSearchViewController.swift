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

    @IBOutlet private weak var errorContainer: UIView!
    @IBOutlet private weak var errorLabel: UILabel!

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
        
    private func configureTextField() {
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let searchIconImageView = UIImageView(image: searchIcon)
        searchTextField.leftView = searchIconImageView
        searchTextField.leftViewMode = .always

        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidEditingChanged), for: .editingChanged)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchAllLeagues() {
        LoadingHUD.showDefaultLoader()
        leagueSearchViewModel.fetchAllLeagues() { [weak self] in
            LoadingHUD.hide()
            
            guard let self else { return }
            
            self.refreshGUI()
        }
    }
    
    private func refreshGUI() {
        errorContainer.isHidden = leagueSearchViewModel.error == nil
        tableView.isHidden = leagueSearchViewModel.error != nil
        
        errorLabel.text = leagueSearchViewModel.error?.localizedDescription
        
        tableView.reloadData()
    }
    
    @IBAction func retryButtonDidTouchUpInside(_ sender: Any) {
        self.fetchAllLeagues()
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
