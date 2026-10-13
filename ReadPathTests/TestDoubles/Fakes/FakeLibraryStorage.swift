//
//  FakeLibraryStorage.swift
//  ReadPath
//
//  Created by Егор on 13.10.2026.
//

import Foundation
@testable import ReadPath

final class FakeLibraryStorage: CoreDataLibraryStorageProtocol {
    var error: TestError?
    var saveError: TestError?
    var savedBooks: [SavedBook] = []
    
    func saveBook(_ book: ReadPath.SavedBook) throws {
        if let saveError {
            throw saveError
        }
        savedBooks.append(book)
    }
    
    func loadBooks() throws -> [ReadPath.SavedBook] {
        if let error {
            throw error
        }
        return savedBooks
    }
    
    func changeStatus(key: String, status: ReadPath.ReadingStatus) throws {
        if let error {
            throw error
        }
        guard let index = savedBooks.firstIndex(where: { $0.key == key } ) else { return }
        let oldBook = savedBooks[index]
        let newBook = SavedBook(
            key: oldBook.key,
            title: oldBook.title,
            coverID: oldBook.coverID,
            status: status,
            addedAt: oldBook.addedAt
        )
        savedBooks[index] = newBook
    }
    
    func containsBook(key: String) throws -> Bool {
        if let error {
            throw error
        }
        return savedBooks.contains { book in
            book.key == key
        }
    }
    
    func deleteBook(key: String) throws {
        if let error {
            throw error
        }
        savedBooks.removeAll { book in
            book.key == key
        }
    }
}
