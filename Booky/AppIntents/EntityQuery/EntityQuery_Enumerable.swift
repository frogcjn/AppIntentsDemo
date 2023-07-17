//
//  File.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/16/23.
//

import protocol AppIntents.EnumerableEntityQuery
import struct AppIntents.IntentDescription
/*
struct EnumerableEntityQuery_BookEntity: EnumerableEntityQuery, EntityQuery_BookEntity {
    static var findIntentDescription: IntentDescription? {
        .init(
            """
            Search Book with property filters and sorters. EnumerableEntityQuery
            """,
            categoryName: "Searching"
        )
    }
    
    @MainActor
    func allEntities() async throws -> [BookEntity] {
        try context.fetchAllBookEntities()
    }
}
*/
