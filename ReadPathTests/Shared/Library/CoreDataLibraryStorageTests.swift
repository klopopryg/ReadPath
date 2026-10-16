//
//  CoreDatalibraryStorageTests.swift
//  ReadPath
//
//  Created by Егор on 15.10.2026.
//

import Testing
@testable import ReadPath
import CoreData

@MainActor
final class CoreDataLibraryStorageTests {
    
    @Test func savedBookCanBeLoaded() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead)
        try storage.saveBook(book)
        let readContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        readContext.persistentStoreCoordinator = container.persistentStoreCoordinator
        let readStorage = CoreDataLibraryStorage(context: readContext)
        let loadedBooks = try readStorage.loadBooks()
        #expect(loadedBooks == [book])
    }
    
    @Test func loadBooksReturnsEmptyArrayWhenStorageIsEmpty() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let loadedBooks = try storage.loadBooks()
        #expect(loadedBooks == [])
    }
    
    @Test func saveBookDoesNotCreateDuplicate() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead)
        try storage.saveBook(book)
        try storage.saveBook(book)
        let loadedBooks = try storage.loadBooks()
        #expect(loadedBooks == [book])
    }
    
    @Test func changeStatusUpdatesSavedBookStatus() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead)
        try storage.saveBook(book)
        try storage.changeStatus(key: book.key, status: .completed)
        let readContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        readContext.persistentStoreCoordinator = container.persistentStoreCoordinator
        let readStorage = CoreDataLibraryStorage(context: readContext)
        let loadedBooks = try readStorage.loadBooks()
        #expect(loadedBooks.count == 1)
        #expect(loadedBooks.first?.key == book.key)
        #expect(loadedBooks.first?.status == .completed)
    }
    
    @Test func deleteBookRemovesOnlyMatchingBook() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let firstBook = makeBook(key: "firstBook", status: .wantToRead)
        let secondBook = makeBook(key: "secondBook", status: .wantToRead)
        try storage.saveBook(firstBook)
        try storage.saveBook(secondBook)
        try storage.deleteBook(key: secondBook.key)
        let readContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        readContext.persistentStoreCoordinator = container.persistentStoreCoordinator
        let readStorage = CoreDataLibraryStorage(context: readContext)
        let loadedBooks = try readStorage.loadBooks()
        #expect(loadedBooks == [firstBook])
    }
    
    @Test func containsBookReturnsTrueForSavedBook() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead)
        try storage.saveBook(book)
        let isContains = try storage.containsBook(key: book.key)
        #expect(isContains == true)
    }
    
    @Test func containsBookReturnsFalseForMissingBook() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let isContains = try storage.containsBook(key: "book")
        #expect(isContains == false)
    }
    
    @Test func saveBookPreservesCoverID() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead, coverID: 1)
        try storage.saveBook(book)
        let loadedBooks = try storage.loadBooks()
        #expect(loadedBooks.first?.coverID == 1)
        #expect(loadedBooks.count == 1)
    }
    
    @Test func saveBookPreservesMissingCoverID() throws {
        let container = try makeContainer()
        let storage = CoreDataLibraryStorage(context: container.viewContext)
        let book = makeBook(key: "book", status: .wantToRead)
        try storage.saveBook(book)
        let loadedBooks = try storage.loadBooks()
        #expect(loadedBooks.count == 1)
        #expect(loadedBooks.first?.coverID == nil)
    }
    
    private func makeContainer() throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ReadPath")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        var loadingError: Error?
        
        container.loadPersistentStores { _, error in
            loadingError = error
        }
        
        if let loadingError {
            throw loadingError
        }
        
        return container
    }
}
