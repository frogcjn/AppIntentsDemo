//
//  NewBookView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI
import SwiftData

struct NewBookView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: ViewModel
    
    @State private var title = ""
    @State private var author = ""
    @State private var isRead = false
    @State private var datePublished = Date()
    @State private var uiImage: UIImage? = nil
    
    @Environment(\.modelContext)
    var context
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title, prompt: Text("Title"))
                TextField("Author", text: $author, prompt: Text("Author"))
                DatePicker("Published", selection: $datePublished, displayedComponents: .date)
                Toggle("Read", isOn: $isRead)
                HStack {
                    Text("Image") 
                    Spacer()
                    Button {
                        vm.showingImagePicker = true
                    } label: {
                        if let uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        }
                    }

                }
            }
            .textInputAutocapitalization(.words)
            .sheet(isPresented: $vm.showingImagePicker) {
                ImagePicker(image: $uiImage)
            }
            .navigationTitle("New Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.red)
                    })
                }
                ToolbarItem {
                    Button {
                        context.insert(Book(title: title, author: author, uiImage: uiImage, isRead: isRead, datePublished: datePublished))
                        dismiss()
                    } label: {
                        Text("Save")
                            .bold()
                    }
                    .disabled(title == "" || author == "")
                }
            }
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
