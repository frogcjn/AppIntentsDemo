//
//  ContentView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    @AppStorage("isFirstRun")
    var isFirstRun = true
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var vm: ViewModel
    
    @Query(sort: \Book.title, order: .forward)
    private var books: [Book]
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            List {
                if books.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            try? context.insertDummyBooks()
                        } label: {
                            Text("Add Dummy Books")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Spacer()
                    }
                } else {
                    ForEach(books) { book in
                        NavigationLink(value: book, label: {
                            ListRowView(book: book)
                        })
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem {
                    Button {
                        vm.showingAddNewBook = true
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $vm.showingAddNewBook) {
                NewBookView()
                    .environment(\.modelContext, context)
                    .environmentObject(vm)
            }
            .onAppear {
                if isFirstRun {
                    // Adds 3 dummy books to the library on first run
                    if let _ = try? context.insertDummyBooks() {
                        isFirstRun = false
                    }
                }
            }
        }
    }
    
    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            context.deleteBooks(offsets.map { books[$0] })
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
