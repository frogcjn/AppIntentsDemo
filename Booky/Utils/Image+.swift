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

// UIImage, IntentFile -> Data

extension Book {
    convenience init(
                 uuid: UUID? = nil,
                title: String,
               author: String,
              uiImage: UIImage?,
               isRead: Bool,
        datePublished: Date? = nil
    ) {
        self.init(
                     uuid: uuid,
                    title: title,
                   author: author,
                imageData: uiImage?.jpegData(compressionQuality: 1),
                   isRead: isRead,
            datePublished: datePublished
        )
    }
    
    convenience init(
                 uuid: UUID? = nil,
                title: String,
               author: String,
            imageFile: IntentFile?,
               isRead: Bool,
        datePublished: Date? = nil
    ) {
        self.init(
                     uuid: uuid,
                    title: title,
                   author: author,
                imageData: imageFile?.data,
                   isRead: isRead,
            datePublished: datePublished
        )
    }
}


// Data -> ImageFile

extension BookEntity {
    init(
                 uuid: UUID,
                title: String,
               author: String,
            imageData: Data?,
               isRead: Bool,
        datePublished: Date
    ) {
        self.init(
                     uuid: uuid,
                    title: title,
                   author: author,
                imageFile: imageData?.imageFile(uuid: uuid),
                   isRead: isRead,
            datePublished: datePublished
        )
    }
}

extension Data {
    func imageFile(uuid: UUID) -> IntentFile {
        IntentFile(data: self, filename: "\(uuid).jpg")
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

