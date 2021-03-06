//
//  TabBarController.swift
//  Makub
//
//  Created by Елена Яновская on 20.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        static var newsImage = "newspaper"
        static var ratingImage = "star"
        static var gamesImage = "fighting"
        static var accountImage = "menu"
    }
    
    // MARK: - Private Properties
    
    private let newsStoryboard = UIStoryboard(with: StoryboardTitle.news)
    private let ratingStoryboard = UIStoryboard(with: StoryboardTitle.rating)
    private let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
    private let accountStoryboard = UIStoryboard(with: StoryboardTitle.account)
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarController()
        configureTabBar()
    }

    // MARK: - Private Properties
    
    private func createTabBarController() {
        let newsItem = UIImage(named: Constants.newsImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let newsVC = newsStoryboard.viewController(NewsViewController.self)
        newsVC.tabBarItem = UITabBarItem(title: nil, image: newsItem, tag: 0)
        
        let ratingItem = UIImage(named: Constants.ratingImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let ratingVC = ratingStoryboard.viewController(RatingViewController.self)
        ratingVC.tabBarItem = UITabBarItem(title: nil, image: ratingItem, tag: 1)
        
        let gamesItem = UIImage(named: Constants.gamesImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let gamesVC = gamesStoryboard.viewController(GamesViewController.self)
        gamesVC.tabBarItem = UITabBarItem(title: nil, image: gamesItem, tag: 2)
        
        let accountItem = UIImage(named: Constants.accountImage)?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        let accountVC = accountStoryboard.viewController(AccountViewController.self)
        accountVC.tabBarItem = UITabBarItem(title: nil, image: accountItem, tag: 3)
        accountVC.delegate = newsVC
        
        let controllerArray = [newsVC, ratingVC, gamesVC, accountVC]
        viewControllers = controllerArray.map { UINavigationController(rootViewController: $0) }
    }
    
    private func configureTabBar() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 0.5)
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        tabBar.barTintColor = .white
        tabBar.tintColor = PaletteColors.blueTint
    }
}
