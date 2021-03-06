//
//  NewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class NewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
        static let moreButton = "more"
    }
    
    private enum LayoutConstants {
        static let imageDistance: CGFloat = 15
        static let minImageDistance: CGFloat = 5
    }
    
    private enum SizeConstants {
        static let photoWidth: CGFloat = 200
        static let photoHeight: CGFloat = 200
        
        static let imageWidth: CGFloat = 501
        static let imageHeight: CGFloat = 1077
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var authorImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var illustrationImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var moreButton: UIButton!
    
    @IBOutlet private var lineView: UIView!
    
    @IBOutlet private var heightIllustrationImageView: NSLayoutConstraint!
    @IBOutlet private var imageDistance: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    weak var delegate: NewsCellDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: NewsViewModel!
    private let indicator = UserIndicator()
    
    private var heightIllustrationImageViewConstant: CGFloat!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moreButton.isHidden = true
        configureLayout()
        configureFont()
        configureColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        authorImageView.image = nil
        dateLabel.text = nil
        illustrationImageView.image = nil
        moreButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: NewsViewModel) {
        self.viewModel = viewModel
        
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.text
        authorLabel.text = viewModel.fullName
        
        if let imageURL = viewModel.imageURL {
            heightIllustrationImageView.constant = heightIllustrationImageViewConstant
            imageDistance.constant = LayoutConstants.imageDistance
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.imageWidth, height: SizeConstants.imageHeight), mode: .aspectFill)
            illustrationImageView.kf.indicatorType = .activity
            illustrationImageView.kf.setImage(with: URL(string: imageURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.heightIllustrationImageView.constant = 0
                    self.imageDistance.constant = LayoutConstants.minImageDistance
                }
            })
        } else {
            self.imageDistance.constant = LayoutConstants.minImageDistance
            heightIllustrationImageView.constant = 0
        }
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.photoWidth, height: SizeConstants.photoHeight), mode: .aspectFill)
            authorImageView.kf.indicatorType = .custom(indicator: indicator)
            authorImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.authorImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            authorImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    func configureMoreButton(userId: String) {
        moreButton.setTitle("", for: .normal)
        if viewModel.authorId == userId {
            moreButton.setImage(UIImage(named: Constants.moreButton), for: .normal)
            moreButton.tintColor = PaletteColors.textGray
            moreButton.isHidden = false
        }
    }
    
    func configureCellWidth(_ width: CGFloat) {
        let imageOffset: CGFloat = 16
        heightIllustrationImageViewConstant = (width - imageOffset) / 3 * 2
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    private func configureFont() {
        authorLabel.font = UIFont.customFont(.robotoMediumFont(size: 15))
        dateLabel.font = UIFont.customFont(.robotoRegularFont(size: 12))
        titleLabel.font = UIFont.customFont(.robotoBoldFont(size: 16))
        descriptionLabel.font = UIFont.customFont(.robotoRegularFont(size: 15))
        
        titleLabel.setLineSpacing(lineSpacing: 3)
        descriptionLabel.setLineSpacing(lineSpacing: 3)
    }
    
    private func configureColor() {
        authorLabel.textColor = PaletteColors.darkGray
        dateLabel.textColor = PaletteColors.textGray
        titleLabel.textColor = PaletteColors.darkGray
        descriptionLabel.textColor = PaletteColors.textGray
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    // MARK: - IBAction
    
    @IBAction func moreButtonTapped(_ sender: NewsCell) {
        guard let tag = Int(viewModel.id) else { return }
        sender.tag = tag
        delegate?.moreButtonTapped(sender)
    }
    
}
