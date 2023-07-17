//
//  BookStatus.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import protocol AppIntents.AppEnum
import struct AppIntents.DisplayRepresentation
import struct AppIntents.TypeDisplayRepresentation

// These will be the options in the Shortcut action to mark the book as read or unread
enum BookStatus: String {
    case read
    case unread
}

extension BookStatus: AppEnum {
    
    // This will be displayed as the title of the menu shown when picking from the options
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Status")
    
    // The strings that will be shown for each item in the menu
    static var caseDisplayRepresentations: [BookStatus: DisplayRepresentation] = [
        .read: "Read",
        .unread: "Unread"
    ]
    
    var isRead: Bool {
        switch self {
            case .read: true
            case.unread: false
        }
    }
}
