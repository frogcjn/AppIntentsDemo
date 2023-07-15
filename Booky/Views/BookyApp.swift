//
//  BookyApp.swift
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import SwiftData

@main
struct BookyApp: App {
    
    @StateObject
    var viewModel = ViewModel.shared
    
    @Environment(\.modelContext)
    var context
        
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.modelContext, ModelContext.shared)
                .environmentObject(viewModel)
        }
    }
}
