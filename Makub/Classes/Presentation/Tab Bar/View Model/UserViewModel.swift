//
//  UserViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct UserViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let photo: String!
    
    // MARK: - Initialization
    
    init(_ user: User) {
        guard let photo = user.photo else {
            self.photo = nil
            return
        }
        self.photo = Constants.baseURL + photo
    }
}
