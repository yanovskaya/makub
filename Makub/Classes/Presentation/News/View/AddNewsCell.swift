//
//  AddNewsCell.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Kingfisher
import UIKit

final class AddNewsCell: UICollectionViewCell, ViewModelConfigurable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let userImage = "photo_default"
        static let addNewsLabel = "Создать новую запись"
    }
    
    private enum SizeConstants {
        static let userWidth: CGFloat = 200
        static let userHeight: CGFloat = 200
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var addNewsLabel: UILabel!
    
    // MARK: - Private Property
    
    private let indicator = UserIndicator()
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    // MARK: - Prepare for Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: UserViewModel?) {
        guard let viewModel = viewModel else { return }
        if let photoURL = viewModel.photoURL {
            let sizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: SizeConstants.userWidth, height: SizeConstants.userHeight), mode: .aspectFill)
            userImageView.kf.indicatorType = .custom(indicator: indicator)
            userImageView.kf.setImage(with: URL(string: photoURL), placeholder: nil, options: [.processor(sizeProcessor)], completionHandler: { (image, _, _, _) in
                if image == nil {
                    self.userImageView.image = UIImage(named: Constants.userImage)
                }
            })
        } else {
            self.userImageView.image = UIImage(named: Constants.userImage)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    private func configureLabel() {
        addNewsLabel.font = UIFont.customFont(.robotoRegularFont(size: 16))
        addNewsLabel.text = Constants.addNewsLabel
        addNewsLabel.textColor = PaletteColors.textGray
    }
}
