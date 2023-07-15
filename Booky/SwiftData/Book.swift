//
//  BookEntity.swift
//  
//
//  Created by Cao, Jiannan on 7/15/23.
//
//

import Foundation
import SwiftData


@Model
class Book {
    @Attribute(.unique)
    var uuid: UUID
    
    var author: String = ""
    var coverImage: Data?
    var datePublished: Date?
    var isRead: Bool = false
    var title: String = ""
    
    init(uuid: UUID = .init(), title: String = "", author: String = "", coverImage: Data? = nil, datePublished: Date? = nil, isRead: Bool = false) {
        self.uuid = uuid
        self.title = title
        self.author = author
        self.coverImage = coverImage
        self.datePublished = datePublished
        self.isRead = isRead
    }
}
