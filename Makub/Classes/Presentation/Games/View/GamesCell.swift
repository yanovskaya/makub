//
//  GamesCell.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class GamesCell: UITableViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "user"
    }

    // MARK: - IBOutlets
    
    @IBOutlet private var stageLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    
    @IBOutlet private var photo1ImageView: UIImageView!
    @IBOutlet private var photo2ImageView: UIImageView!
    @IBOutlet private var player1Label: UILabel!
    @IBOutlet private var player2Label: UILabel!
    @IBOutlet private var score1Label: UILabel!
    @IBOutlet private var score2Label: UILabel!
    
    // MARK: - Private Property
    
    private var firstPlayerWon: Bool! {
        didSet {
            configureScoreColor()
        }
    }
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
        configureColor()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: GamesViewModel) {
        firstPlayerWon = score1 > score2
        typeLabel.text = viewModel.type
        score1Label.text = viewModel.score1
        score2Label.text = viewModel.score2
        player1Label.text = viewModel.player1
        player2Label.text = viewModel.player2
        
        if let photo1URL = viewModel.photo1URL {
            photo1ImageView.kf.indicatorType = .activity
            photo1ImageView.kf.setImage(with: URL(string: imageURL))
        } else {
            photo1ImageView.image = UIImage(named: Constants.userImage)
        }
        if let photo2URL = viewModel.photo2URL {
            photo2ImageView.kf.indicatorType = .activity
            photo2ImageView.kf.setImage(with: URL(string: photoURL))
        } else {
            photo2ImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureFont() {
        player1Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        player2Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        typeLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        score1Label.font = UIFont.customFont(.robotoMediumFont(size: 20))
        score2Label.font = UIFont.customFont(.robotoMediumFont(size: 14))
        stageLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
    }
    
    private func configureColor() {
        player1Label.textColor = PaletteColors.darkGray
        player2Label.textColor = PaletteColors.darkGray
        typeLabel.textColor = PaletteColors.textGray
        stageLabel.textColor = PaletteColors.darkGray
    }
    
    private func configureScoreColor() {
        if firstPlayerWon {
            score1Label.textColor = PaletteColors.winColor
            score2Label.textColor = PaletteColors.loseColor
        } else {
            score1Label.textColor = PaletteColors.loseColor
            score2Label.textColor = PaletteColors.winColor
        }
    }
}
