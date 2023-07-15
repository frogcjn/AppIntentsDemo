//
//  AppIntents+SwiftData.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import AppIntents
import SwiftData

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
