//
//  OpenShelf.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/4/23.
//

import AppIntents

struct OpenShelf: AppIntent {
    static var title: LocalizedStringResource = "Open Shelf"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Shelf")
    var shelf: Shelf

    @MainActor
    func perform() async throws -> some IntentResult {
        // Navigator.shared.openShelf(shelf)
        return .result()
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$shelf)")
    }
}
