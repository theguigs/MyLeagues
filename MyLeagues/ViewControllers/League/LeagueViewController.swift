//
//  LeagueViewController.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit

class LeagueViewController: EnginedViewController {

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private property
    private lazy var leagueViewModel = LeagueViewModel(engine: engine)
    private let league: League
    
    init(engine: Engine, league: League) {
        self.league = league
        
        super.init(engine: engine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = league.strLeague
        
        configureCollectionView()
        
        fetchAllTeams()
    }

    private func fetchAllTeams() {
        LoadingHUD.showDefaultLoader()
        leagueViewModel.fetchAllTeams(for: league) { [weak self] in
            LoadingHUD.hide()

            guard let self else { return }
            
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            UINib(nibName: TeamCollectionViewCell.kReuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: TeamCollectionViewCell.kReuseIdentifier
        )
    }
}

extension LeagueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leagueViewModel.teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TeamCollectionViewCell.kReuseIdentifier,
            for: indexPath
        ) as? TeamCollectionViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let team = leagueViewModel.teams[indexPath.row]
        cell.configure(team: team)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        return CGSize(width: width, height: width)
    }
}
