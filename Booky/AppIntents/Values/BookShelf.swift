//
//  Shelf.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import protocol AppIntents.AppEnum
import struct AppIntents.DisplayRepresentation
import struct AppIntents.TypeDisplayRepresentation

enum BookShelf: String {
    case currentlyReading
    case wantToRead
    case read
}

extension BookShelf: AppEnum {
    
    //static var typeDisplayName: LocalizedStringResource = "Shelf"
    
    static var caseDisplayRepresentations: [BookShelf: DisplayRepresentation] = [
        .currentlyReading: "Currently Reading",
        .wantToRead: "Want to Read",
        .read: "Read"
    ]
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Shelf"
    }
}
