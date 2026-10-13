//
//  SavedBookFactory.swift
//  ReadPath
//
//  Created by Егор on 13.10.2026.
//

import Foundation
@testable import ReadPath

func makeBook(key: String, status: ReadingStatus) -> SavedBook {
    let savedBook = SavedBook(
        key: key,
        title: "",
        coverID: nil,
        status: status,
        addedAt: Date()
    )
    return savedBook
}
