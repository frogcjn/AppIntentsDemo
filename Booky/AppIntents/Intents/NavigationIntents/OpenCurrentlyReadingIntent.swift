//
//  OpenCurrentlyReading.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import Foundation
import protocol AppIntents.AppIntent
import protocol AppIntents.IntentResult
import struct AppIntents.IntentDescription

struct OpenCurrentlyReadingIntent: AppIntent {
    @MainActor
    func perform() async throws -> some IntentResult {
        // Navigator.shared.openShelf(.currentlyReading)
        return .result()
    }  
}

extension OpenCurrentlyReadingIntent {
    // Title of the action in the Shortcuts app
    static var title: LocalizedStringResource = "Open Currently Reading"
    // Description of the action in the Shortcuts app
    static var description: IntentDescription = IntentDescription(
        "This action will open the selected book in the Booky app or navigate to the home library.",
    categoryName: "Navigation")
    // This opens the host app when the action is run
    static var openAppWhenRun = true
}
