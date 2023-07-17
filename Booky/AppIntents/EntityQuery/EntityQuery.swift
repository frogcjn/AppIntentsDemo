//
//  EntityQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/16/23.
//

import Foundation
import protocol AppIntents.EntityQuery

protocol EntityQuery_BookEntity : EntityQuery {}

extension EntityQuery_BookEntity {
    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    @MainActor
    func entities(for uuids: [UUID]) async throws -> [BookEntity] {
        context.fetchBookEntities(uuids: uuids)
    }
    
    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
    @MainActor
    func suggestedEntities() async throws -> [BookEntity] {
        try context.fetchAllBookEntities()
    }
}
