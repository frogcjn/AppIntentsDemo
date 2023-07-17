//
//  BookQuery.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import Foundation
import SwiftData
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

struct PropertyEntityQuery_BookEntity_SwiftData: EntityPropertyQuery {
    
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
    
    static var findIntentDescription: IntentDescription? {
        return IntentDescription(
            """
            Search Book with property filters and sorters. D
            """,
            categoryName: "Searching")
    }
    
    typealias ComparatorMappingType = (PredicateExpressions.Variable<Book>) -> any StandardPredicateExpression<Bool>

    static var properties = QueryProperties {
        Property(\BookEntity.$title) {
            EqualToComparator { value in
                {
                    PredicateExpressions.build_Equal(
                        lhs: PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.title
                        ),
                        rhs: PredicateExpressions.build_Arg(value)
                    )
                }
            }
            ContainsComparator { value in
                {
                    PredicateExpressions.build_contains(
                        PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.title
                        ),
                        PredicateExpressions.build_Arg(value)
                    )
                }
            }
        }
        /*Property(\BookEntity.$author) {
            EqualToComparator { value in
                {
                    PredicateExpressions.build_Equal(
                        lhs: PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.author
                        ),
                        rhs: PredicateExpressions.build_Arg(value)
                    )
                }
            }
            ContainsComparator { value in
                {
                    PredicateExpressions.build_contains(
                        PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.author
                        ),
                        PredicateExpressions.build_Arg(value)
                    )
                }
            }
        }
        Property(\BookEntity.$datePublished) {
            LessThanComparator { value in
                {
                    PredicateExpressions.build_Comparison(
                        lhs: PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.datePublished
                        ),
                        rhs: PredicateExpressions.build_Arg(value),
                        op: .lessThan
                    )
                }
            }
            GreaterThanComparator { value in
                {
                    PredicateExpressions.build_Comparison(
                        lhs: PredicateExpressions.build_KeyPath(
                            root: PredicateExpressions.build_Arg($0),
                            keyPath: \.datePublished
                        ),
                        rhs: PredicateExpressions.build_Arg(value),
                        op: .greaterThan
                    )
                }
            }
        }*/
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
        let predicate: Predicate<Book>
        switch mode {
        case .and, .or:
            predicate = Predicate<Book> {
                let exp : any StandardPredicateExpression<Bool> = comparators[0]($0)
                return unbox(t: exp)
            }
            
        }
        let sortDescriptors: [SortDescriptor<Book>] = sortedBy.map(Book.sortDescriptor(fromEntity:))

        var fetchDescriptor = FetchDescriptor<Book>(predicate: predicate)
        // !!!: there is no way to combine multiple Swift Predicates into one Predicate, and set it into fetchDescriptor.
        fetchDescriptor.predicate = predicate
        fetchDescriptor.sortBy = sortDescriptors
        fetchDescriptor.fetchLimit = limit
        
        do {
            return try ModelContext.main.fetch(fetchDescriptor).map(\.bookEntity)
        } catch let error {
            print(error)
            throw error
        }
        // !!!: the only possible work-around is to fetch all book then evaluate by each predicate.
    }
         
}

func unbox<T: StandardPredicateExpression<Bool>> (t: T) -> T { t }

struct MyPredictateExpression : StandardPredicateExpression {
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
    
    init(from decoder: Decoder) throws {
        fatalError()
    }
    
    func evaluate(_ bindings: PredicateBindings) throws -> Bool {
        print(bindings)
        return true
    }
    init(){}
}

struct AnyStandardPredicateExpression<Output>: StandardPredicateExpression {
    func evaluate(_ bindings: PredicateBindings) throws -> Output {
        try expression.evaluate(bindings)
    }
    
    let expression: any StandardPredicateExpression<Output>
    internal init(expression: any StandardPredicateExpression<Output>) {
        self.expression = expression
    }
    
    func encode(to encoder: Encoder) throws {
        try expression.encode(to: encoder)
    }
    
    init(from decoder: Decoder) throws {
        fatalError()
    }
}

struct AnyRequest<Response, Error: Swift.Error> {
    typealias Handler = (Result<Response, Error>) -> Void

    let perform: (@escaping Handler) -> Void
    let handler: Handler
}

extension StandardPredicateExpression<Bool> {
    func xf() -> Predicate<Book> { Predicate<Book>{ (v: PredicateExpressions.Variable<Book>) in
        let a = self
        return a
    } }
}
