//
//  ListRowView.swift
//  Booky
//
//  Created by Alex Hay on 07/06/2022.
//

import SwiftUI

struct ListRowView: View {
    
    @State
    var book: Book
    
    @Environment(\.modelContext)
    var context
    
    var body: some View {
        HStack {
            Group {
                if let data = book.imageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 64, height: 105)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.teal
                        .frame(width: 64, height: 105)
                        .overlay {
                            Image(systemName: "book.closed")
                                .foregroundColor(.white)
                        }
                }
            }
            .cornerRadius(4)
            .padding(5)
            VStack(alignment: .leading) {
                Text(book.title)
                    .bold()
                Text(book.author)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .lineLimit(1)
            Spacer()
            if book.isRead {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
        .contextMenu {
            Button {
                book.isRead.toggle()
            } label: {
                book.isRead ? Label("Mark as unread", systemImage: "x.circle") : Label("Mark as read", systemImage: "checkmark.circle")
            }
        }
    }
}
