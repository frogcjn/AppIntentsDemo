//
//  File.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/16/23.
//

import AppIntents

struct EntityQueryEnumerable_BookEntity: EnumerableEntityQuery, EntityQuery_BookEntity {
    static var findIntentDescription: IntentDescription? {
        .init(
            """
            Search Book with property filters and sorters.
            """,
            categoryName: "Searching"
        )
    }
    
    @MainActor
    func allEntities() async throws -> [BookEntity] {
        try context.fetchAllBookEntities()
    }
}
