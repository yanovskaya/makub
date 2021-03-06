//
//  Stages.swift
//  Makub
//
//  Created by Елена Яновская on 02.04.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class Tournament: Object, Decodable {
    
    @objc dynamic var id: String! = nil
    @objc dynamic var name: String! = nil
    @objc dynamic var smalldesc: String! = nil
    @objc dynamic var club: String! = nil
    @objc dynamic var status: String! = nil
    @objc dynamic var type: String! = nil
    @objc dynamic var place: String! = nil
    @objc dynamic var date: String! = nil
}
