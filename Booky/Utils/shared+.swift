//
//  AppIntents+SwiftData.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import protocol AppIntents.AppValue
import protocol AppIntents.AppIntent
import protocol AppIntents.DynamicOptionsProvider

import SwiftData
import CoreData


extension ModelContext {
    @MainActor
    static var main: ModelContext { ModelContainer.shared.mainContext }
}

extension NSManagedObjectContext {
    static var main: NSManagedObjectContext { NSPersistentContainer.shared.viewContext }
}

extension BookEntity {
    @MainActor
    static var context: ModelContext { ModelContext.main }
    static var nsContext: NSManagedObjectContext { NSManagedObjectContext.main }
}

extension AppIntent {
    @MainActor
    var context: ModelContext { ModelContext.main }
}

extension AppValue {
    @MainActor
    var context: ModelContext { ModelContext.main }
}

extension DynamicOptionsProvider {
    @MainActor
    var context: ModelContext { ModelContext.main }
}
