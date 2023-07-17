//
//  BookQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import CoreData
import protocol AppIntents.EntityPropertyQuery
import struct AppIntents.IntentDescription
import class AppIntents.EqualToComparator
import class AppIntents.ContainsComparator
import class AppIntents.LessThanComparator
import class AppIntents.LessThanOrEqualToComparator
import class AppIntents.GreaterThanComparator
import class AppIntents.GreaterThanOrEqualToComparator
import class AppIntents.IsBetweenComparator
import class AppIntents.EqualToComparator
import class AppIntents.NotEqualToComparator

struct PropertyEntityQuery_BookEntity_CoreData: EntityQuery_BookEntity, EntityPropertyQuery {
    
    static var persistentIdentifier: String {
        "PropertyEntityQuery_BookEntity_CoreData"
    }
    
    static var findIntentDescription: IntentDescription? {
        .init(
            """
            Search Book with property filters and sorters. PropertyEntityQuery_BookEntity (Core Data)
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
            LessThanOrEqualToComparator { NSPredicate(format: "datePublished <= %@", $0 as NSDate) }
            GreaterThanComparator { NSPredicate(format: "datePublished > %@", $0 as NSDate) }
            GreaterThanOrEqualToComparator { NSPredicate(format: "datePublished > %@", $0 as NSDate) }
            IsBetweenComparator { NSPredicate(format: "datePublished >= %@ && datePublished <= %@", $0 as NSDate, $1 as NSDate) }
            EqualToComparator { NSPredicate(format: "datePublished == %@", $0 as NSDate) }
            NotEqualToComparator { NSPredicate(format: "datePublished != %@", $0 as NSDate) }
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

