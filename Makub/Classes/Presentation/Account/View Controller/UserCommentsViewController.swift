//
//  UserCommentsViewController.swift
//  Makub
//
//  Created by Елена Яновская on 24.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import PKHUD
import UIKit

class UserCommentsViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let backImage = "arrow_left"
        static let cellIdentifier = String(describing: CommentsCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 5
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 15
        static let estimatedCellHeight: CGFloat = 114
        static let cellSpacing: CGFloat = 3
    }
    
    // MARK: - Public Properties
    
    let presentationModel = UserCommentsPresentationModel()
    
    // MARK: - Private Properties
    
    private var refreshControl = UIRefreshControl()
    private let router = AccountRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PaletteColors.blueBackground
        
        configureNavigationBar()
        configureCollectionView()
        bindEvents()
        presentationModel.obtainAllComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentationModel.commentsViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let commentsViewModel = presentationModel.commentsViewModels[indexPath.row]
        let cellIdentifier = Constants.cellIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CommentsCell else { return UICollectionViewCell() }
        
        cell.configure(for: commentsViewModel)
        cell.configureCellWidth(view.frame.width)
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.showUserGameInfoVCFromComments(source: self, indexPath.row)
    }
    
    // MARK: - Private Methods
    
    private func bindEvents() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            case .rich:
                self?.collectionView?.reloadData()
                HUD.hide()
            case .error (let code):
                switch code {
                case -1009, -1001:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.network.rawValue))
                default:
                    HUD.show(.labeledError(title: ErrorDescription.title.rawValue, subtitle: ErrorDescription.server.rawValue))
                }
                HUD.hide(afterDelay: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func bindEventsRefreshUserGames() {
        presentationModel.changeStateHandler = { [weak self] status in
            switch status {
            case .loading:
                break
            case .rich:
                self?.collectionView?.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
            case .error:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let titleTextAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: PaletteColors.darkGray,
                                                                 NSAttributedStringKey.font: UIFont.customFont(.robotoMediumFont(size: 17))]
        navigationBar.titleTextAttributes = titleTextAttributes
        title = presentationModel.title
        
        let backButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        backButtonItem.image = UIImage(named: Constants.backImage)
        backButtonItem.tintColor = PaletteColors.darkGray
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAllGames(_:)), for: .valueChanged)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.estimatedItemSize.width = view.frame.width
        flowLayout.estimatedItemSize.height = LayoutConstants.estimatedCellHeight
    }
    
    @objc private func refreshAllGames(_ refreshControl: UIRefreshControl) {
        bindEventsRefreshUserGames()
        presentationModel.refreshAllComments()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserCommentsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}
