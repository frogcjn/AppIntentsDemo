//
//  BookQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents
import CoreData

struct BookEntityPropertyQuery_CoreData: BookEntityQuery, EntityPropertyQuery {
    
    static var findIntentDescription: IntentDescription? {
        .init(
            """
            Search Book with property filters and sorters.
            """,
            categoryName: "Searching"
        )
    }
    
    typealias ComparatorMappingType = NSPredicate
    static var properties = QueryProperties {
        Property(\BookEntity.$title) {
            EqualToComparator { NSPredicate(format: "title = %@", $0) }
            ContainsComparator { NSPredicate(format: "title CONTAINS %@", $0) }
            
        }
        Property(\BookEntity.$author) {
            EqualToComparator { NSPredicate(format: "author = %@", $0) }
            ContainsComparator { NSPredicate(format: "author CONTAINS %@", $0) }
        }
        Property(\BookEntity.$datePublished) {
            LessThanComparator { NSPredicate(format: "datePublished < %@", $0 as NSDate) }
            GreaterThanComparator { NSPredicate(format: "datePublished > %@", $0 as NSDate) }
        }
    }
    
    static var sortingOptions = SortingOptions {
        SortableBy(\BookEntity.$title)
        SortableBy(\BookEntity.$author)
        SortableBy(\BookEntity.$datePublished)
    }
    
    
    func entities(
        matching comparators: [ComparatorMappingType],
        mode: ComparatorMode,
        sortedBy: [Sort<BookEntity>],
        limit: Int?
    ) async throws -> [BookEntity] {
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        let sortDescriptors = sortedBy.map { NSSortDescriptor(key: "\($0.by)", ascending: $0.order == .ascending) }
        
        let request = CDBook.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let limit { request.fetchLimit = limit }
        
        return try NSManagedObjectContext.main.fetch(request).map(\.bookEntity)
    }
}

