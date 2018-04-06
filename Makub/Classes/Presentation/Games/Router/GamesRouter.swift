//
//  GamesRouter.swift
//  Makub
//
//  Created by Елена Яновская on 06.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class GamesRouter {
    
    // MARK: - Private Properties
    
    private let gamesStoryboard = UIStoryboard(with: StoryboardTitle.games)
    
    // MARK: - Public Methods
    
    /// News -> AddNews.
    func presentFilterGamesVC(source gamesViewController: GamesViewController) {
        let filterGamesViewController = gamesStoryboard.viewController(FilterGamesViewController.self)
        //let presentationModel = newsViewController.presentationModel
        //addNewsViewController.presentationModel = presentationModel
        //addNewsViewController.delegate = newsViewController
        gamesViewController.present(filterGamesViewController, animated: true)
    }
}
