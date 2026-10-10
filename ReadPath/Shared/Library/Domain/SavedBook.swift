//
//  SavedBook.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

import Foundation

struct SavedBook: Equatable {
    let key: String
    let title: String
    let coverID: Int?
    let status: ReadingStatus
    let addedAt: Date
}
