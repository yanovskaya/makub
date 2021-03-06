//
//  UserGamesResponse.swift
//  Makub
//
//  Created by Елена Яновская on 23.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

struct UserGamesResponse: Decodable {
    
    let games: [UserGame]!
    let error: Int
}
