//
//  LibraryStorageProtocol.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

protocol CoreDataLibraryStorageProtocol {
    func saveBook(_ book: SavedBook) throws
    func loadBooks() throws -> [SavedBook]
    func changeStatus(key: String, status: ReadingStatus) throws
    func containsBook(key: String) throws -> Bool
    func deleteBook(key: String) throws
}
