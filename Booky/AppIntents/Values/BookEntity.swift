//
//  BookEntity.swift
//  Booky
//
//  Created by Alex Hay on 08/06/2022.
//

import Foundation
import protocol AppIntents.AppEntity
import   struct AppIntents.IntentFile
import   struct AppIntents.TypeDisplayRepresentation
import   struct AppIntents.DisplayRepresentation

// A structure that defines a book object from Booky in the Shortcuts app
// If you don't want all the query capabilities and want a disposable object you can output from Shortcuts with parameters, use the TransientEntity protocol instead: https://developer.apple.com/documentation/appintents/transiententity
struct BookEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation  = "Book"
    
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
    
    @Property(title: "Title")
    var title: String
    
    @Property(title: "Author")
    var author: String
    
    @Property(title: "Cover Image")
    var imageFile: IntentFile?
    
    @Property(title: "Is Read")
    var isRead: Bool
    
    @Property(title: "Date Published")
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

