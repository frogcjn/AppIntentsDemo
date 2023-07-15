//
//  Container.swift
//  Booky
//
//  Created by Cao, Jiannan on 7/16/23.
//

import SwiftData

extension ModelContainer {
    static let shared = try! ModelContainer(for: [Book.self])
}
