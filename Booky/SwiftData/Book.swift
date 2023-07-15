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
    
    var title: String
    
    var author: String
    
    @Attribute(.externalStorage)
    var imageData: Data?
        
    var datePublished: Date

    var isRead: Bool
    
    init(
                 uuid: UUID? = nil,
                title: String,
               author: String,
            imageData: Data?,
               isRead: Bool,
        datePublished: Date? = nil
    ) {
        self         .uuid = uuid ?? UUID()
        self        .title = title
        self       .author = author
        self    .imageData = imageData
        self       .isRead = isRead
        self.datePublished = datePublished ?? .now
    }
}
