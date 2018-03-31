//
//  NewsPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import UIKit

final class NewsPresentationModel: PresentationModel {
    
    // MARK: - Public Properties
    
    var userViewModel: UserViewModel!
    var newsViewModels = [NewsViewModel]()
    
    // MARK: - Private Properties
    
    private let userService = ServiceLayer.shared.userService
    private let newsService = ServiceLayer.shared.newsService
    
    private var userCacheIsObtained = false
    private var newsCacheIsObtained = false

    private let group = DispatchGroup()
    
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainNews() {
        group.enter()
        obtainUserCache()
        if !userCacheIsObtained { state = .loading }
        userService.obtainUserInfo { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.enter()
        state = .loading
        newsService.obtainNews { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.flatMap { NewsViewModel($0) }
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
        }
        
    }
    
    func refreshNews() {
        group.enter()
        obtainUserCache()
        userService.obtainUserInfo { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.userViewModel = UserViewModel(model)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.enter()
        newsService.obtainNews { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.newsViewModels = model.news.flatMap { NewsViewModel($0) }
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
                self.group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
        }
        
    }
    
    func addNews(title: String, text: String, completion: @escaping () -> Void) {
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state = .rich
            completion()
        }
//        newsService.addNews(title: title, text: text) { result in
//            switch result {
//            case .serviceSuccess:
//                self.state = .rich
//                completion()
//            case .serviceFailure(let error):
//                self.state = .error(code: error.code)
//            }
//        }
    }
    
    func addNewsWithImage(title: String, text: String, image: UIImage, completion: @escaping () -> Void) {
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.state = .rich
            completion()
        }
//        newsService.addNewsWithImage(title: title, text: text, image: image) { result in
//            switch result {
//            case .serviceSuccess:
//                self.state = .rich
//               // completion!()
//            case .serviceFailure(let error):
//                self.state = .error(code: error.code)
//            }
//        }
    }
    
    // MARK: - Private Methods
    
    private func obtainUserCache() {
        userService.obtainRealmCache(error: nil) { [weak self] result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self?.userViewModel = UserViewModel(model)
                self?.state = .rich
                self?.userCacheIsObtained = true
            case .serviceFailure:
                break
            }
        }
    }
    
}
