//
//  BookQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents
import SwiftData

struct BookEntityPropertyQuery_SwiftData: BookEntityQuery, EntityPropertyQuery {
    
    static var findIntentDescription: IntentDescription? {
        return IntentDescription(
            """
            Search Book with property filters and sorters.
            """,
            categoryName: "Searching")
    }
    
    typealias ComparatorMappingType = Predicate<Book>

    static var properties = QueryProperties {
       Property(\BookEntity.$title) {
            EqualToComparator { value in #Predicate<Book> { $0.title == value } }
            ContainsComparator { value in #Predicate<Book> { $0.title.contains(value) } }

        }
        Property(\BookEntity.$author) {
            EqualToComparator { value in #Predicate<Book> { $0.author == value } }
            ContainsComparator { value in #Predicate<Book> { $0.author.contains(value) }  }
        }
        Property(\BookEntity.$datePublished) {
            LessThanComparator { value in #Predicate<Book> { $0.datePublished < value } }
            GreaterThanComparator { value in #Predicate<Book> { $0.datePublished > value } }
        }
    }
    
    static var sortingOptions = SortingOptions {
        SortableBy(\BookEntity.$title)
        SortableBy(\BookEntity.$author)
        SortableBy(\BookEntity.$datePublished)
    }
    
    @MainActor
    func entities(
        matching comparators: [ComparatorMappingType],
        mode: ComparatorMode,
        sortedBy: [Sort<BookEntity>],
        limit: Int?
    ) async throws -> [BookEntity] {
        // let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        let sortDescriptors: [SortDescriptor<Book>] = sortedBy.map(Book.sortDescriptor(fromEntity:))

        var fetchDescriptor = FetchDescriptor<Book>()
        // fetchDescriptor.predicate = predicate // !!!: there is no way to combine multiple Swift Predicates into one Predicate, and set it into fetchDescriptor.
        fetchDescriptor.sortBy = sortDescriptors
        fetchDescriptor.fetchLimit = limit

        return try ModelContext.main.fetch(fetchDescriptor).map(\.bookEntity)
        // !!!: the only possible work-around is to fetch all book then evaluate by each predicate.
    }
         
}

