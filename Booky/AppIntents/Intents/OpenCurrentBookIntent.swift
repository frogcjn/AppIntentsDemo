//
//  OpenCurrentlyReading.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import AppIntents

struct OpenCurrentBookIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Currently Reading"
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        // Navigator.shared.openShelf(.currentlyReading)
        return .result()
    }
  
}
