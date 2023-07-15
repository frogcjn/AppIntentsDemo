//
//  File.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//
import AppIntents

struct EntityQueryString_BookEntity: EntityQuery_BookEntity, EntityStringQuery {
    // Find books matching the given query.
    @MainActor
    func entities(matching query: String) async throws -> [BookEntity] {
        // Allows the user to filter the list of Books by title or author when tapping on a param that accepts a 'Book'
        try context.fetchAllBookEntities().filter {
            ($0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query))
        }
    }
}
