//
//  BookyApp.swift
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import SwiftData
import CoreData
import AppIntents

@main
struct BookyApp: App, AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = []
    
    @StateObject
    var viewModel = ViewModel.shared
    
    @Environment(\.modelContext)
    var context
        
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.modelContext, ModelContext.main)
                .environment(\.managedObjectContext, NSManagedObjectContext.main)
                .environmentObject(viewModel)
        }
    }
    
    init() {
        Self.updateAppShortcutParameters()
    }
}
