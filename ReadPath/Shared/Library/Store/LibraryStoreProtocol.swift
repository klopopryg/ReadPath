//
//  LibraryStoreProtocol.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

protocol LibraryStoreProtocol {
    var savedBooks: [SavedBook] { get }
    
    func addBook(_ book: SavedBook) throws
    func loadBooks() throws
    func changeStatus(key: String, status: ReadingStatus) throws
    func containsBook(key: String) throws -> Bool
    func deleteBook(key: String) throws
    func getSavedBooksCount() -> Int
    func getBookAtIndex(_ index: Int) -> SavedBook
}
