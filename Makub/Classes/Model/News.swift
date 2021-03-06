//
//  News.swift
//  Makub
//
//  Created by Елена Яновская on 24.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation
import RealmSwift

final class News: Object, Decodable {
    
    @objc dynamic var author: String! = nil
    @objc dynamic var id: String! = nil
    @objc dynamic var title: String! = nil
    @objc dynamic var text: String! = nil
    @objc dynamic var tag: String! = nil
    @objc dynamic var date: String! = nil
    @objc dynamic var image: String! = nil
    @objc dynamic var photo: String! = nil
    @objc dynamic var name: String! = nil
    @objc dynamic var surname: String! = nil
}
