//
//  Context+AppIntents.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import Foundation
import SwiftData

import Foundation
import SwiftData
import class UIKit.UIImage

extension ModelContext {
    
    // MARK: - Fetch
    
    fileprivate func fetchBook(uuid: UUID) throws -> Book {
        var fetchDescriptor = FetchDescriptor<Book>()
        fetchDescriptor.predicate = #Predicate { $0.uuid == uuid }
        fetchDescriptor.fetchLimit = 1
        guard let book = try fetch(fetchDescriptor).first else {
            throw Error.notFound
        }
        return book
    }
    
    fileprivate func fetchBooks(uuids: [UUID]) -> [Book] {
        uuids.compactMap{ try? fetchBook(uuid: $0) }
    }
    
    func fetchAllBooks() throws -> [Book] {
        var fetchDescriptor = FetchDescriptor<Book>()
        fetchDescriptor.sortBy = [.init(\.title, order: .forward)]
        return try fetch(fetchDescriptor)
    }
    
    // MARK: - Insert
    
    // Inserts 3 dummy books to the library
    func insertDummyBooks() {
        let books = [
            Book(
                title: "The Hobbit",
                author: "J.R.R. Tolkien",
                uiImage: UIImage(named: "hobbit"),
                isRead: true,
                datePublished: DateComponents(year: 1937, month: 09, day: 21).date
            ),
            Book(
                title: "To Kill A Mockingbird",
                author: "Harper Lee",
                uiImage: UIImage(named: "mocking"),
                isRead: true,
                datePublished: DateComponents(year: 1960, month: 07, day: 11).date
            ),
            Book(
                title: "The Queen Of Hearts",
                author: "Kimmery Martin",
                uiImage: UIImage(named: "queen"),
                isRead: false,
                datePublished: DateComponents(year: 2018, month: 02, day: 15).date
            )
        ]
        books.forEach(insert(object:))
    }
    
    // MARK: - Delete
    
    fileprivate func deleteBooks(uuids:[UUID]) throws {
        deleteBooks(try uuids.map(fetchBook(uuid:)))
    }
    
    func deleteBooks(_ books:[Book]) {
        books.forEach(delete(object:))
    }
}


extension ModelContext {
    
    // MARK: - Fetch to BookEntity
    
    /*fileprivate func fetchBookEntity(uuid: UUID) throws  -> BookEntity {
        try fetchBook(uuid: uuid).entity
    }*/
    
    func fetchBookEntities(uuids: [UUID]) -> [BookEntity] {
        fetchBooks(uuids: uuids).map(\.entity)
    }
    
    func fetchAllBookEntities() throws -> [BookEntity] {
        try fetchAllBooks().map(\.entity)
    }
    
    // MARK: - Fetch from BookEntity
    
    fileprivate func fetchBook(entity: BookEntity) throws  -> Book {
        try fetchBook(uuid: entity.uuid)
    }
        
    // MARK: - Delete BookEntity
    
    func deleteBookEntities(_ entities: [BookEntity]) throws {
        try deleteBooks(uuids: entities.map(\.uuid))
    }
    
    // MARK: - Update BookEntity
    
    func markBookEntities( _ entities: [BookEntity], status: BookStatus) throws {
        try entities.map(\.uuid).map(fetchBook(uuid:)).forEach { $0.isRead = status.isRead }
    }
}

// Book -> BookEntity

extension BookEntity {
    init(book: Book) {
        self.init(uuid: book.uuid, title: book.title, author: book.author, imageData: book.imageData, isRead: book.isRead, datePublished: book.datePublished)
    }
}

extension Book {
    var entity: BookEntity {
        .init(book: self)
    }
}

// BookEntity -> Book

extension BookEntity {
    @MainActor
    var book: Book {
        get throws {
            try context.fetchBook(entity: self)
        }
    }
}

extension Book {
    @MainActor
    fileprivate class func from(entity: BookEntity) throws -> Book {
        try entity.book
    }
}
