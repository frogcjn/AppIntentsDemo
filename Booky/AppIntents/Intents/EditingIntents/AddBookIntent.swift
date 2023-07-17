//
//  ShowBook.swift
//  Booky
//
//  Created by Alex Hay on 10/06/2022.
//

import SwiftUI
import protocol AppIntents.AppIntent

import struct AppIntents.IntentDialog
import struct AppIntents.IntentDescription
import protocol AppIntents.ParameterSummary

import protocol AppIntents.IntentResult
import protocol AppIntents.ReturnsValue
import struct AppIntents.IntentFile


struct AddBookIntent: AppIntent {
    
    // String input options allow you to set the keyboard type, capitalization and more
    @Parameter(
                     title: "Title",
               description: "The title of the new book",
              inputOptions: String.IntentInputOptions(capitalizationType: .words),
        requestValueDialog: IntentDialog("What is the title of the book?")
    )
    var bookTitle: String

    @Parameter(
                     title: "Author",
               description: "The author of the new book's name",
              inputOptions: String.IntentInputOptions(capitalizationType: .words),
        requestValueDialog: IntentDialog("What is the author of the book's name?")
    )
    var author: String
    
    // Optionally accept an image to set as the book's cover. We can define the types of files that are accepted
    @Parameter(
                           title: "Cover Image",
                     description: "An optional image of the book's cover",
        supportedTypeIdentifiers: ["public.image"],
              requestValueDialog: IntentDialog("What image should be used as the cover of the book?")
    )
    var imageFile: IntentFile?

    @Parameter(
                     title: "Read",
               description: "Toggle on if you have read the book",
                   default: false,
        requestValueDialog: IntentDialog("Have you read the book?")
    )
    var isRead: Bool
    
    @Parameter(
                     title: "Date Published",
               description: "The date the book was published",
        requestValueDialog: IntentDialog("What date was the book published?")
    )
    var datePublished: Date?
    
    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws ->  some IntentResult & ReturnsValue<BookEntity> {
        let book = Book(
                    title: "\(bookTitle)",
                   author: "\(author)",
                imageFile: imageFile,
                   isRead: isRead,
            datePublished: datePublished
        )
        context.insert(book)
        return .result(value: book.bookEntity) { // <-- we output the 'Book' to be used in the next shortcut action
            
            // Including a trailing closure with a SwiftUI view adds a 'Show When Run' button to the Shortcut action
            // If this is toggled, the view will be shown as a 'Snippet' then the result is output
            // A snippet is an archived SwiftUI View (similar to a medium-size widget)
            // You can use multiple Links() in Snippets which will open in the background
            // Like widgets, you cannot use animated or interactive elements like ScrollViews
            BookView(book: book, smallImage: true)
        }
    }
}


extension AddBookIntent {
    // The name of the action in Shortcuts
    static let title: LocalizedStringResource = "Add Book"
    
    // Description of the action in Shortcuts
    // Category name allows you to group actions - shown when tapping on an app in the Shortcuts library
    static let description = IntentDescription(
        """
        Add a new book to your collection.

        A preview of the new book is optionally shown as a Snippet after the action has run.
        """,
        categoryName: "Editing"
    )
    
    // How the summary will appear in the shortcut action.
    // More parameters are included below the fold in the trailing closure. In Shortcuts, they are listed in the reverse order they are listed here
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$bookTitle) by \(\.$author) with \(\.$imageFile)") {
            \.$datePublished
            \.$isRead
        }
    }
}
