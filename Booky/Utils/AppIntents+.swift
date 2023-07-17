//
//  AppIntents+.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/16/23.
//

import Foundation
import struct AppIntents.EntityQuerySort

extension EntityQuerySort.Ordering {
    var value: SortOrder {
        switch self {
        case .ascending: SortOrder.forward
        case .descending: SortOrder.reverse
        }
    }
}

extension Book {
    static func sortDescriptor(fromEntity querySort: EntityQuerySort<BookEntity>) -> SortDescriptor<Book> {
        let order = querySort.order.value
        let keyPath = querySort.by
        return switch keyPath {
        case         \.$title: SortDescriptor(        \Book.title, order: order)
        case        \.$author: SortDescriptor(       \Book.author, order: order)
        case \.$datePublished: SortDescriptor(\Book.datePublished, order: order)
        default: fatalError()
        }
    }
}
