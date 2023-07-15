//
//  BookQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents
import SwiftData

struct QueryBooksIntent: EntityPropertyQuery {
    
    typealias ComparatorMappingType = Predicate<BookEntity>
    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    @MainActor
    func entities(for uuids: [UUID]) async throws -> [BookEntity] {
        context.fetchBookEntities(uuids: uuids)
    }
    
    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
    @MainActor
    func suggestedEntities() async throws -> [BookEntity] {
        try context.fetchAllBooks().map {
            BookEntity(book: $0)
        }
    }
    
    // Find books matching the given query.
    @MainActor
    func entities(matching query: String) async throws -> [BookEntity] {
        // Allows the user to filter the list of Books by title or author when tapping on a param that accepts a 'Book'
        let allBooks = try context.fetchAllBooks()
        let matchingBooks = allBooks.filter {
            return ($0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query))
        }

        return matchingBooks.map {
            BookEntity(book: $0)
        }
    }
         
   static var properties = QueryProperties {
       Property(\BookEntity.$title) {
            EqualToComparator { title in #Predicate<BookEntity> { $0.title == title } }
            ContainsComparator { title in #Predicate<BookEntity> { $0.title.contains(title) } }

        }
        Property(\BookEntity.$author) {
            EqualToComparator { author in #Predicate<BookEntity> { $0.author == author } }
            ContainsComparator { author in #Predicate<BookEntity> { $0.author.contains(author) }  }
        }
        Property(\BookEntity.$datePublished) {
            LessThanComparator { date in #Predicate { $0.datePublished < date } }
            GreaterThanComparator { date in #Predicate<BookEntity> { $0.datePublished > date } }
        }
    }
    
    static var sortingOptions = SortingOptions {
        SortableBy(\.$title)
        SortableBy(\.$author)
        SortableBy(\.$datePublished)
    }
    
    static var findIntentDescription: IntentDescription? {
        return IntentDescription(
    """
    Add a new book to your collection.

    A preview of the new book is optionally shown as a Snippet after the action has run.
    """, categoryName: "Searching")
    }
    
    @MainActor
    func entities(
        matching filters: [ComparatorMappingType],
        mode: ComparatorMode,
        sortedBy comparators: [Sort<BookEntity>],
        limit: Int?
    ) async throws -> [BookEntity] {

        do {
            var fetchDescriptor: FetchDescriptor<Book> = .init()
            fetchDescriptor.fetchLimit = limit
            var matchingBooks = try context.fetch(fetchDescriptor).map {
                BookEntity(book: $0)
            }
            for filter in filters {
                matchingBooks = try matchingBooks.filter(filter)
            }
            
            matchingBooks = matchingBooks.sorted(using: comparators.map { comparator in
                let order: SortOrder = switch comparator.order {
                case .ascending: SortOrder.forward
                case .descending: SortOrder.reverse
                }
                
                return switch comparator.by {
                case \BookEntity.author:
                    SortDescriptor<BookEntity>(\BookEntity.author, order: order)
                case \BookEntity.datePublished:
                    SortDescriptor<BookEntity>(\BookEntity.datePublished, order: order)
                case \BookEntity.title:
                    SortDescriptor<BookEntity>(\BookEntity.title, order: order)
                default:
                    SortDescriptor<BookEntity>(\BookEntity.title, order: order)
                }
            })
            print("here2")
            return []

        } catch let error {
            print(error)
            return []
        }
        
    }
}
/*

struct AnyPredicateExpression<Output> : StandardPredicateExpression {

    let wrapped: any StandardPredicateExpression<Output>
    
    func encode(to encoder: Encoder) throws {
        try wrapped.encode(to: encoder)
    }
    
    init(wrapped: any StandardPredicateExpression<Output>) {
        self.wrapped = wrapped
    }
    
    init(from decoder: Decoder) throws {
        throw NSError()
    }

    func evaluate(_ bindings: PredicateBindings) throws -> Output {
        try wrapped.evaluate(bindings)
    }
}*/

enum Comparator {
    case titleContains(String)
    case titleEqual(String)
    case authorContains(String)
    case authorEqual(String)
    case datePublishedLessThan(Date)
    case datePublishedMoreThan(Date)
}



/*
// Used if not providing an advanced filtering action?
// Allow Shortcuts to query Booky's database for Books
struct IntentsBookQuery: EntityPropertyQuery {
    
    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    func entities(for identifiers: [UUID]) async throws -> [BookEntity] {
        return identifiers.compactMap { identifier in
                if let match = try? BookManager.shared.findBook(withId: identifier) {
                    return BookEntity(
                        id: match.id,
                        title: match.title,
                        author: match.author,
                        coverImageData: match.coverImage,
                        isRead: match.isRead,
                        datePublished: match.datePublished)
                } else {
                    return nil
                }
        }
    }
    
    // Find books matching the given query.
    // When the user taps a parameter that accepts Books and types into the search bar at the top, this is where the results are populated from
    func entities(matching query: String) async throws -> [BookEntity] {
        print("Finding books containing '\(query)'")
        // Allows the user to filter the list of Books by title or author
        let allBooks = BookManager.shared.getAllBooks()
        let matchingBooks = allBooks.filter {
            return ($0.title.localizedCaseInsensitiveContains(query) || $0.author.localizedCaseInsensitiveContains(query))
        }

        return matchingBooks.map {
            BookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
     
    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
    func suggestedEntities() async throws -> [BookEntity] {
        let allBooks = BookManager.shared.getAllBooks()
        return allBooks.map {
            BookEntity(
                id: $0.id,
                title: $0.title,
                author: $0.author,
                coverImageData: $0.coverImage,
                isRead: $0.isRead,
                datePublished: $0.datePublished)
        }
    }
}
 */
