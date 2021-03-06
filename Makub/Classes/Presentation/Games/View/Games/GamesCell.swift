//
//  GamesCell.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class GamesCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
        static let videoImage = "video"
    }

    private enum SizeConstants {
        static let photoWidth: CGFloat = 200
        static let photoHeight: CGFloat = 200
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var additionalInfoLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var videoImageView: UIImageView!
    
    @IBOutlet private var photo1ImageView: UIImageView!
    @IBOutlet private var photo2ImageView: UIImageView!
    @IBOutlet private var player1Label: UILabel!
    @IBOutlet private var player2Label: UILabel!
    @IBOutlet private var score1Label: UILabel!
    @IBOutlet private var score2Label: UILabel!
    
    @IBOutlet private var widthVideoImageView: NSLayoutConstraint!
    @IBOutlet private var leadingVideoImageView: NSLayoutConstraint!
    @IBOutlet private var centerVideoImageView: NSLayoutConstraint!
    
    // MARK: - Private Property
    
    private var firstPlayerWon: Bool! {
        didSet {
            configureScoreColor()
        }
    }
    
    private let indicator = UserIndicator()
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photo1ImageView.clipsToBounds = true
        photo1ImageView.layer.cornerRadius = photo1ImageView.frame.width / 2
        
        photo2ImageView.clipsToBounds = true
        photo2ImageView.layer.cornerRadius = photo2ImageView.frame.width / 2
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        additionalInfoLabel.text = nil
        typeLabel.text = nil
        player1Label.text = nil
        player2Label.text = nil
        score1Label.text = nil
        score2Label.text = nil
        photo1ImageView.image = nil
        photo2ImageView.image = nil
        videoImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: GameViewModel) {
        firstPlayerWon = viewModel.score1 > viewModel.score2
        typeLabel.text = viewModel.type
        score1Label.text = viewModel.score1
        score2Label.text = viewModel.score2
        player1Label.text = viewModel.player1
        player2Label.text = viewModel.player2
        additionalInfoLabel.text = viewModel.club
        
        let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
        
        if let photo1URL = viewModel.photo1URL {
            photo1ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo1ImageView.kf.setImage(with: URL(string: photo1URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo1ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo1ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if let photo2URL = viewModel.photo2URL {
            photo2ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo2ImageView.kf.setImage(with: URL(string: photo2URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo2ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo2ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if viewModel.video != nil {
            videoImageView.tintColor = PaletteColors.textGray
            videoImageView.image = UIImage(named: Constants.videoImage)?.withRenderingMode(.alwaysTemplate)
            videoImageView.isHidden = false
            
            centerVideoImageView.isActive = true
            widthVideoImageView.constant = 20
            leadingVideoImageView.constant = 8
        } else {
            videoImageView.removeConstraints([leadingVideoImageView])
            videoImageView.isHidden = true
            centerVideoImageView.isActive = false
            
            leadingVideoImageView.constant = 0
            widthVideoImageView.constant = 0
        }
    }
    
    func configure(userViewModel: UserViewModel, gameViewModel: UserGameViewModel) {
        firstPlayerWon = gameViewModel.ourScore > gameViewModel.hisScore
        typeLabel.text = gameViewModel.type
        score1Label.text = gameViewModel.ourScore
        score2Label.text = gameViewModel.hisScore
        player1Label.text = userViewModel.fullname
        player2Label.text = gameViewModel.player
        additionalInfoLabel.text = gameViewModel.commentsDescription
        
        let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
        
        if let photo1URL = userViewModel.photoURL {
            photo1ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo1ImageView.kf.setImage(with: URL(string: photo1URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo1ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo1ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if let photo2URL = gameViewModel.photoURL {
            photo2ImageView.kf.indicatorType = .custom(indicator: indicator)
            photo2ImageView.kf.setImage(with: URL(string: photo2URL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.photo2ImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            photo2ImageView.image = UIImage(named: Constants.userImage)
        }
        
        if gameViewModel.video != nil {
            videoImageView.tintColor = PaletteColors.textGray
            videoImageView.image = UIImage(named: Constants.videoImage)?.withRenderingMode(.alwaysTemplate)
            videoImageView.isHidden = false
            
            centerVideoImageView.isActive = true
            widthVideoImageView.constant = 20
            leadingVideoImageView.constant = 8
        } else {
            videoImageView.removeConstraints([leadingVideoImageView])
            videoImageView.isHidden = true
            centerVideoImageView.isActive = false
            
            leadingVideoImageView.constant = 0
            widthVideoImageView.constant = 0
        }
    }
    
    // MARK: - Private Methods
    
    private func configureFont() {
        player1Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        player2Label.font = UIFont.customFont(.robotoRegularFont(size: 16))
        typeLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
        score1Label.font = UIFont.customFont(.robotoMediumFont(size: 23))
        score2Label.font = UIFont.customFont(.robotoMediumFont(size: 23))
        additionalInfoLabel.font = UIFont.customFont(.robotoRegularFont(size: 11))
    }
    
    private func configureColor() {
        player1Label.textColor = PaletteColors.darkGray
        player2Label.textColor = PaletteColors.darkGray
        typeLabel.textColor = PaletteColors.textGray
        additionalInfoLabel.textColor = PaletteColors.textGray
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
