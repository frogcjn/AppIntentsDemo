//
//  Book+Image.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/15/23.
//

import Foundation
import class UIKit.UIImage
import struct AppIntents.IntentFile
import struct AppIntents.DisplayRepresentation

// UIImage -> Data

extension Book {
    convenience init(
        uuid: UUID = .init(),
        title: String = "",
        author: String = "",
        uiImage: UIImage? = nil,
        datePublished: Date? = nil,
        isRead: Bool = false
    ) {
        self.init(
            uuid: uuid,
            title: title,
            author: author,
            imageData: uiImage?.jpegData(compressionQuality: 1),
            datePublished: datePublished,
            isRead: isRead
        )
    }
}

// Data -> ImageFile

extension BookEntity {
    init(uuid: UUID, title: String, author: String, imageData: Data?, isRead: Bool, datePublished: Date) {
        self.init(uuid: uuid, title: title, author: author, imageFile: imageData?.imageFile(uuid: uuid), isRead: isRead, datePublished: datePublished)
    }
}

extension Data {
    func imageFile(uuid: UUID) -> IntentFile {
        IntentFile(data: self, filename: "\(uuid).jpg")
    }
}

// ImageFile -> Data

extension Book {
    
    convenience init(
                 uuid: UUID = .init(),
                title: String = "",
               author: String = "",
           intentFile: IntentFile? = nil,
        datePublished: Date? = nil,
               isRead: Bool = false
    ) {
        self.init(
                     uuid: uuid,
                    title: title,
                   author: author,
                imageData: intentFile?.data,
            datePublished: datePublished,
                   isRead: isRead
        )
    }
}

// ImageFile -> Data -> UIImage, DisplayRepresentation.Image

extension IntentFile {
    var uiImage: UIImage? {
        .init(data: data)
    }
    
    var displayRepresentationImage: DisplayRepresentation.Image {
        .init(data: data)
    }
}

