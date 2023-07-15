//
//  BookEntity.swift
//  
//
//  Created by Cao, Jiannan on 7/15/23.
//
//

import Foundation
import SwiftData
import CoreData

@Model
final class Book {
    @Attribute(.unique)
    var uuid: UUID
    
    var title: String
    
    var author: String
    
    var imageData: Data?
        
    var isRead: Bool
    
    var datePublished: Date
    
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
