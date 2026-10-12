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
    }
    
    func containsBook(key: String) throws -> Bool {
        savedBooks.contains { book in
            book.key == key
        }
    }
    
    func deleteBook(key: String) throws {
    }
    
    func getSavedBooksCount() -> Int {
        savedBooks.count
    }
    
    func getBookAtIndex(_ index: Int) -> ReadPath.SavedBook {
        savedBooks[index]
    }
}
