//
//  BookStatus.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents

// These will be the options in the Shortcut action to mark the book as read or unread
enum BookStatus: String, AppEnum {
    case read
    case unread
    
    var isRead: Bool {
        switch self {
            case .read: true
            case.unread: false
        }
    }
}

extension BookStatus {
    
    // This will be displayed as the title of the menu shown when picking from the options
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Status")
    
    // The strings that will be shown for each item in the menu
    static var caseDisplayRepresentations: [BookStatus: DisplayRepresentation] = [
        .read: "Read",
        .unread: "Unread"
    ]
}
