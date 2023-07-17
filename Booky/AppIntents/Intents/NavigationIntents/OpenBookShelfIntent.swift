//
//  OpenShelf.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import protocol AppIntents.AppIntent
import protocol AppIntents.IntentResult
import protocol AppIntents.ParameterSummary
import struct AppIntents.IntentDescription
import Foundation

struct OpenBookShelfIntent: AppIntent {
    @Parameter(title: "Shelf")
    var bookShelf: BookShelf

    @MainActor
    func perform() async throws -> some IntentResult {
        // Navigator.shared.openShelf(shelf)
        return .result()
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$bookShelf)")
    }
}

extension OpenBookShelfIntent {
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Open Shelf"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription(
        "This action will open the selected book in the Booky app or navigate to the home library.",
    categoryName: "Navigation")
    // This opens the host app when the action is run
    static var openAppWhenRun = true
}
