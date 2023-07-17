//
//  OpenBook.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import Foundation
import  protocol AppIntents.OpenIntent
import    struct AppIntents.IntentDialog
import  protocol AppIntents.ParameterSummary
import  protocol AppIntents.IntentResult
import    struct AppIntents.IntentDescription
import  protocol AppIntents.AppIntent
import protocol AppIntents.AppEnum
import protocol AppIntents.CaseDisplayRepresentable
import struct AppIntents.TypeDisplayRepresentation
import struct AppIntents.DisplayRepresentation


// These will be the options in the Shortcut action to open a book or navigate to the library
enum NavigationType: String, AppEnum, CaseDisplayRepresentable {
    
    case library
    case book
    
    // This will be displayed as the title of the menu shown when picking from the options
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Navigation")
    
    static var caseDisplayRepresentations: [NavigationType: DisplayRepresentation] = [
            .library: DisplayRepresentation(title: "Library",
                                            subtitle: "Return to the home page",
                                            image: DisplayRepresentation.Image(systemName: "books.vertical")!),
            .book: DisplayRepresentation(title: "Book",
                                         subtitle: "Navigate to a specific book",
                                         image: DisplayRepresentation.Image(systemName: "book")!)
    ]

}

struct OpenBookIntent: OpenIntent {
    
    // A dynamic lookup parameter
    @Parameter(title: "Book", description: "The book to open in Booky", requestValueDialog: IntentDialog("Which book would you like to open?"))
    var target: BookEntity
    
    // An enum parameter
    @Parameter(title: "Navigation", description: "Choose whether to open a book or navigate to Booky's library", default: .book, requestValueDialog: IntentDialog("What would you like to navigate to?"))
    var navigation: NavigationType
    
    // How the summary will appear in the shortcut action.
    static var parameterSummary: some ParameterSummary {
        
        Switch(\OpenBookIntent.$navigation) {
            Case(NavigationType.book) {
                Summary("Open \(\.$navigation) \(\.$target)")
            }
            Case(NavigationType.library) {
                Summary("Open \(\.$navigation)")
            }
            DefaultCase {
                Summary("Open \(\.$navigation) \(\.$target)")
            }
        }
    }

    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some IntentResult {
        if navigation == .book {
            ViewModel.shared.navigateTo(book: try target.book)
        } else {
            ViewModel.shared.navigateToLibrary()
        }
        return .result()
    }

}

extension OpenBookIntent {
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Open Book"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription(
        "This action will open the selected book in the Booky app or navigate to the home library.",
    categoryName: "Navigation")
    /*// This opens the host app when the action is run
    static var openAppWhenRun = true*/
}
