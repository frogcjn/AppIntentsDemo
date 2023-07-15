//
//  BookEntity.swift
//  Booky
//
//  Created by Alex Hay on 08/06/2022.
//

import Foundation
import AppIntents
import SwiftData

// A structure that defines a book object from Booky in the Shortcuts app
// If you don't want all the query capabilities and want a disposable object you can output from Shortcuts with parameters, use the TransientEntity protocol instead: https://developer.apple.com/documentation/appintents/transiententity
struct BookEntity: Identifiable, Hashable, Equatable, AppEntity {
  
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Book")
    static var defaultQuery = IntentsBookQuery()
    
    var uuid: UUID
    
    @AppEntity.Property(title: "Title")
    var title: String
    
    @AppEntity.Property(title: "Author")
    var author: String
    
    @AppEntity.Property(title: "Cover Image")
    var imageFile: IntentFile?
    
    @AppEntity.Property(title: "Is Read")
    var isRead: Bool
    
    @AppEntity.Property(title: "Date Published")
    var datePublished: Date
    
    init(
                 uuid: UUID,
                title: String,
               author: String,
            imageFile: IntentFile?,
               isRead: Bool,
        datePublished: Date
    ) {
        self         .uuid = uuid
        self        .title = title
        self       .author = author
        self    .imageFile = imageFile
        self       .isRead = isRead
        self.datePublished = datePublished
    }
}

extension BookEntity {
    
    var id: UUID { uuid }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) { hasher.combine(uuid) }
    
    // Equtable conformance
    static func ==(lhs: BookEntity, rhs: BookEntity) -> Bool { lhs.uuid == rhs.uuid }
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(author)",
            image: imageFile?.displayRepresentationImage ?? .init(systemName: "book.closed")
        )
    }
}

