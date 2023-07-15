//
//  MarkBooksAsRead.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import AppIntents



struct MarkBooksStatusIntent: AppIntent {
    // An enum parameter
    @Parameter(
                     title: "Status",
               description: "Can be 'read' or 'unread'",
        requestValueDialog: IntentDialog("How should the books be marked?")
    )
    var status: BookStatus
    
    // A dynamic lookup parameter that allows multiple selections
    @Parameter(
                     title: "Books",
               description: "The books to mark as read or unread",
        requestValueDialog: IntentDialog("Which books would you like to edit?"),
           optionsProvider: BookSectionsOptionsProvider()
    )
    var books: [BookEntity]
        
    @MainActor // <-- include if the code needs to be run on the main thread
    func perform() async throws -> some IntentResult {
        
        // Code here is executed when the shortcut action is run
        try context.markBookEntities(books, status: status)
        return .result()
    }
}

extension MarkBooksStatusIntent {
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Mark Books Status"

    // Description of the action in the Shortcuts app
    // Category name allows you to group actions - shown when tapping on an app in the Shortcuts library
    // Search Keywords allow users to match terms not included in the title or description
    static var description: IntentDescription =  IntentDescription("Mark the chosen books in your library as either read or unread.",
                                                                   categoryName: "Editing",
                                                                   searchKeywords: ["complete", "finished"])

    // How the summary will appear in the shortcut action
    static var parameterSummary: some ParameterSummary {
        Summary("Mark \(\.$books) as \(\.$status)")
    }
}

extension MarkBooksStatusIntent {
    // Here we section the parameter options list into books that are 'read' and 'unread' by using a DynamicOptionsProvider
    struct BookSectionsOptionsProvider: DynamicOptionsProvider {
        @MainActor
        func results() async throws -> ItemCollection<BookEntity> {
            
            let allBooks = try context.fetchAllBooks().map {
                BookEntity(book: $0)
            }
            let readBooks = allBooks.filter{ $0.isRead }
            let unreadBooks = allBooks.filter{ !$0.isRead }
            
            return ItemCollection {
                ItemSection("Unread", items: unreadBooks.map {
                        IntentItem<BookEntity>.init(
                            $0,
                            title: LocalizedStringResource(stringLiteral: $0.title),
                            subtitle: LocalizedStringResource(stringLiteral: $0.author),
                            image: $0.imageFile?.displayRepresentationImage ?? .init(systemName: "person")
                        )
                    }
                )
                ItemSection("Read", items: readBooks.map {
                        IntentItem<BookEntity>.init(
                            $0,
                            title: LocalizedStringResource(stringLiteral: $0.title),
                            subtitle: LocalizedStringResource(stringLiteral: $0.author),
                            image: $0.imageFile?.displayRepresentationImage ?? .init(systemName: "person")
                        )
                    }
                )
            }
        }
    }
}
