//
//  FakeLibraryStore.swift
//  ReadPath
//
//  Created by Егор on 12.10.2026.
//

@testable import ReadPath

final class FakeLibraryStore: LibraryStoreProtocol {
    var savedBooks: [ReadPath.SavedBook] = []
    var error: TestError?
    
    func addBook(_ book: ReadPath.SavedBook) throws {

    }
    
    func loadBooks() throws {
        if let error {
            throw error
        }
    }
    
    func changeStatus(key: String, status: ReadPath.ReadingStatus) throws {
        if let error {
            throw error
        }
        
        guard let index = savedBooks.firstIndex(where: { $0.key == key } ) else { return }
        let book = savedBooks[index]
        let newBook = SavedBook(
            key: book.key,
            title: book.title,
            coverID: book.coverID,
            status: status,
            addedAt: book.addedAt
        )
        savedBooks[index] = newBook
    }
    
    func containsBook(key: String) throws -> Bool {
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
    
    func getSavedBooksCount() -> Int {
        savedBooks.count
    }
    
    func getBookAtIndex(_ index: Int) -> ReadPath.SavedBook {
        savedBooks[index]
    }
}
