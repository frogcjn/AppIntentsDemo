//
//  DeleteBooks.swift
//  Booky
//
//  Created by Alex Hay on 12/06/2022.
//

import Foundation

import protocol AppIntents.DeleteIntent

import struct AppIntents.IntentDialog
import struct AppIntents.IntentDescription
import protocol AppIntents.IntentResult
import protocol AppIntents.ParameterSummary

struct DeleteBooksIntent: DeleteIntent {
    // A dynamic lookup parameter
    @Parameter(
                     title: "Books",
               description: "The books to be deleted from the library",
        requestValueDialog: IntentDialog("Which books would you like to delete?")
    )
    var entities: [BookEntity]
    
    @Parameter(
              title: "Confirm Before Deleting",
        description: "If toggled, you will need to confirm the books will be deleted",
            default: true
    )
    var confirmBeforeDeleting: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if confirmBeforeDeleting {
            let titles = entities.map(\.title)
            let uiImages = entities.compactMap(\.imageFile).compactMap(\.uiImage)
            
            // Here we prompt the user for confirmation before performing the deletion. User cancellation will throw an error
            try await requestConfirmation(result:
                .result(
                    dialog: "Are you sure you want to delete \(titles.formatted(.list(type: .and, width: .short)))?"
                ) {
                    // This 'bookshelf' will visually display the first 4 of the books that are being deleted in the prompt
                    BookshelfView(images: uiImages)
                }
            )
        }
        try context.deleteBookEntities(entities)
        return .result(dialog: IntentDialog(stringLiteral: (entities.count == 1) ? "Book deleted" : "\(entities.count) books deleted"))
    }
}

extension DeleteBooksIntent {
    
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Delete Books"
    
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription(
        """
        This action will delete the selected books.

        By default you will be prompted for confirmation before the books are deleted from your library.
        """,
        categoryName: "Editing"
    )
    
    static var parameterSummary: some ParameterSummary {
        When(\DeleteBooksIntent.$confirmBeforeDeleting, .equalTo, true, {
            Summary("Delete \(\.$entities)") {
                \.$confirmBeforeDeleting
            }
        }, otherwise: {
            Summary("Immediately delete \(\.$entities)") {
                \.$confirmBeforeDeleting
            }
        })
    }
}
