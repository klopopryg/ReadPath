//
//  LibraryStorageProtocol.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

final class LibraryStore: LibraryStoreProtocol {
    private let libraryStorage: CoreDataLibraryStorageProtocol
    private(set) var savedBooks: [SavedBook] = []
    
    init(libraryStorage: CoreDataLibraryStorageProtocol) {
        self.libraryStorage = libraryStorage
    }
    
    func addBook(_ book: SavedBook) throws {
        guard try !libraryStorage.containsBook(key: book.key) else { return }
        try libraryStorage.saveBook(book)
        try loadBooks()
    }
    
    func loadBooks() throws {
        let loadedBooks = try libraryStorage.loadBooks()
        savedBooks = loadedBooks
    }
    
    func changeStatus(key: String, status: ReadingStatus) throws {
        try libraryStorage.changeStatus(key: key, status: status)
        try loadBooks()
    }
    
    func containsBook(key: String) throws -> Bool {
        try libraryStorage.containsBook(key: key)
    }
    
    func deleteBook(key: String) throws {
        try libraryStorage.deleteBook(key: key)
        try loadBooks()
    }
    
    func getSavedBooksCount() -> Int {
        savedBooks.count
    }
    
    func getBookAtIndex(_ index: Int) -> SavedBook {
        savedBooks[index]
    }
}
