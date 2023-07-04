//
//  Shelf.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import AppIntents

enum Shelf: String {
    case currentlyReading
    case wantToRead
    case read
}

extension Shelf: AppEnum {
    
    //static var typeDisplayName: LocalizedStringResource = "Shelf"
    
    static var caseDisplayRepresentations: [Shelf: DisplayRepresentation] = [
        .currentlyReading: "Currently Reading",
        .wantToRead: "Want to Read",
        .read: "Read"
    ]
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Shelf"
    }
}
