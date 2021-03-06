//
//  GameInfoPresentationModel.swift
//  Makub
//
//  Created by Елена Яновская on 14.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class GameInfoPresentationModel: PresentationModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let friendGame = "Товарищеский матч"
    }
    
    // MARK: - Public Properties
    
    var gameViewModel: GameViewModel!
    var gameInfoViewModel: GameInfoViewModel!
    var tournamentViewModel: TournamentForGameViewModel!
    var commentViewModels = [CommentViewModel]()
    var userViewModel: UserViewModel!
    
    // MARK: - Private Properties
    
    private let gameInfoService = ServiceLayer.shared.gameInfoService
    private let userService = ServiceLayer.shared.userService
    
    private let group = DispatchGroup()
    private var error: Int!
    
    // MARK: - Public Methods
    
    func obtainGame() {
        error = nil
        group.enter()
        obtainUserInfo()
        
        group.enter()
        obtainGameInfo()
        
        group.enter()
        obtainComments()
        
        if gameViewModel.stage != "0" {
            group.enter()
            obtainTournament()
        } else {
            tournamentViewModel = TournamentForGameViewModel(title: Constants.friendGame)
        }
        
        group.notify(queue: DispatchQueue.main) {
            if self.error != nil {
                self.state = .error(code: self.error)
            } else {
                self.state = .rich
            }
        }
    }
    
    func obtainOnlyComments() {
        state = .loading
        guard let gameId = Int(gameViewModel.id) else { return }
        gameInfoService.obtainComments(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.commentViewModels = model.comments.compactMap { CommentViewModel($0) }
                self.state = .rich
            case .serviceFailure(let error):
                self.state = .error(code: error.code)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func obtainUserInfo() {
        state = .loading
        userService.obtainUserInfo(useCache: true) { result in
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
    }
    
    private func obtainGameInfo() {
        guard let gameId = Int(gameViewModel.id) else { return }
        gameInfoService.obtainGameInfo(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.gameInfoViewModel = GameInfoViewModel(model)
                self.group.leave()
            case .serviceFailure:
                self.group.leave()
            }
        }
    }
    
    private func obtainTournament() {
        state = .loading
        guard let stage = Int(gameViewModel.stage) else { return }
        gameInfoService.obtainTournament(stage: stage) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.tournamentViewModel = TournamentForGameViewModel(model.tournament)
                self.group.leave()
            case .serviceFailure(let error):
                self.error = error.code
            }
        }
    }
    
    private func obtainComments() {
        state = .loading
        guard let gameId = Int(gameViewModel.id) else { return }
        gameInfoService.obtainComments(gameId: gameId) { result in
            switch result {
            case .serviceSuccess(let model):
                guard let model = model else { return }
                self.commentViewModels = model.comments.compactMap { CommentViewModel($0) }
                self.group.leave()
            case .serviceFailure:
                self.group.leave()
            }
        }
    }
}
