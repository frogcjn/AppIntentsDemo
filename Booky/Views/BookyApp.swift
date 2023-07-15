//
//  BookyApp.swift
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI

@main
struct BookyApp: App {
    
    @StateObject
    var viewModel = ViewModel.shared
    
    @Environment(\.modelContext)
    var context
        
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.modelContext, BookManager.shared.context)
                .environmentObject(viewModel)
        }
    }
    
}
