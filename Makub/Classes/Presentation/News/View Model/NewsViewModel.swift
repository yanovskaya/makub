//
//  NewsViewModel.swift
//  Makub
//
//  Created by Елена Яновская on 25.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class NewsViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://makub.ru"
    }
    
    // MARK: - Public Properties
    
    let id: String
    let authorId: String
    let title: String
    let text: String
    let date: String
    let tag: String
    let fullName: String
    let imageURL: String!
    let photoURL: String!
    
    // MARK: - Initialization
    
    init(_ news: News) {
        self.id = news.id
        authorId = (news.author != nil) ? news.author : ""
        text = (news.text != nil) ? news.text.removeTags() : ""
        title = (news.title != nil) ? news.title : ""
        tag = (news.tag != nil) ? news.tag : ""
        
        if let date = news.date.dateConverter()?.0 {
            self.date = date
        } else if let date = news.date {
            self.date = date
        } else {
            self.date = ""
        }
        
        if let name = news.name,
            let surname = news.surname {
            self.fullName = name + " " + surname
        } else {
            self.fullName = ""
        }
        
        if let photo = news.photo, photo != "" {
            self.photoURL = (Constants.baseURL + photo).encodeInURL()
        } else {
            self.photoURL = nil
        }
        
        if let image = news.image, image != "" {
            self.imageURL = (Constants.baseURL + image).encodeInURL()
        } else {
            self.imageURL = nil
        }
    }
}
