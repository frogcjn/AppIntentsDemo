//
//  AppIntents+SwiftData.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents
import SwiftData

extension ModelContainer {
    static let shared = try! ModelContainer(for: [Book.self])
}

extension ModelContext {
    @MainActor
    static var shared: ModelContext {
        ModelContainer.shared.mainContext
    }
}

extension AppIntent {
    @MainActor
    var context: ModelContext { ModelContext.shared }
}

extension EntityQuery {
    @MainActor
    var context: ModelContext { ModelContext.shared }
}

extension DynamicOptionsProvider {
    @MainActor
    var context: ModelContext { ModelContext.shared }
}

extension AppEntity {
    @MainActor
    var context: ModelContext { ModelContext.shared }
}
