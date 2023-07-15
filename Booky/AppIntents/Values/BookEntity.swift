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
struct BookEntity: AppEntity {
  
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Book")
    
    // MARK: Default Query Options
    
    // option 1: String Entity Query
    //static var defaultQuery = StringEntityQuery_BookEntity()

    // option 2: Enumerable Entity Query
    // static var defaultQuery = EnumerableEntityQuery_BookEntity()
    
    // option 3: Property Entity Query
    // option 3-1: Property Entity Query - SwiftData version
    static var defaultQuery = PropertyEntityQuery_BookEntity_SwiftData() // !!!: SwiftData version: lack of multiple-predicates filter feature
    
    // option 3-2: Property Entity Query - CoreData version
    // static var defaultQuery = PropertyEntityQuery_BookEntity_CoreData() // !!!: CoreData version: OK with multiple-predicates filter feature
    
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

