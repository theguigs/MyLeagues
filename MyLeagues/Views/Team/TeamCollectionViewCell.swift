//
//  TeamCollectionViewCell.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit
import Kingfisher

class TeamCollectionViewCell: UICollectionViewCell {
    static let kReuseIdentifier = "TeamCollectionViewCell"
    
    @IBOutlet private weak var teamImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        teamImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        teamImageView.clipsToBounds = false
        
        teamImageView.layer.shadowOpacity = 0.3
        teamImageView.layer.shadowOffset = .zero
    }

    func configure(team: Team) {
        guard let url = URL(string: team.strTeamBadge) else { return }
        teamImageView.kf.setImage(with: url)
    }
}
