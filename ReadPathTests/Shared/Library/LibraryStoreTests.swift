//
//  LibraryStoreTests.swift
//  ReadPath
//
//  Created by Егор on 13.10.2026.
//

import Testing
@testable import ReadPath

final class LibraryStoreTests {
    
    @Test func loadBooksUpdatesSavedBooksFromStorage() throws {
        let fakeLibraryStorage = FakeLibraryStorage()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStorage.savedBooks = [wantToRead, completed]
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        try libraryStore.loadBooks()
        let expectedBooks = [wantToRead, completed]
        #expect(libraryStore.savedBooks == expectedBooks)
    }
    
    @Test func addNewBookUpdatesSavedBooks() throws {
        let fakeLibraryStorage = FakeLibraryStorage()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        fakeLibraryStorage.savedBooks = [wantToRead]
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        try libraryStore.loadBooks()
        #expect(libraryStore.savedBooks == fakeLibraryStorage.savedBooks)
        let completed = makeBook(key: "completed", status: .completed)
        try libraryStore.addBook(completed)
        let expectedBooks = [wantToRead, completed]
        #expect(libraryStore.savedBooks == expectedBooks)
    }
    
    @Test func addExistingBookDoesNotCreateDuplicate() throws {
        let fakeLibraryStorage = FakeLibraryStorage()
        let book = makeBook(key: "wantToRead", status: .wantToRead)
        fakeLibraryStorage.savedBooks = [book]
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        try libraryStore.loadBooks()
        #expect(libraryStore.savedBooks == fakeLibraryStorage.savedBooks)
        try libraryStore.addBook(book)
        let expectedBooks = [book]
        #expect(fakeLibraryStorage.savedBooks == expectedBooks)
        #expect(libraryStore.savedBooks == expectedBooks)
    }
    
    @Test func deleteBooksUpdatesSavedBooks() throws {
        let fakeLibraryStorage = FakeLibraryStorage()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStorage.savedBooks = [wantToRead, completed]
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        try libraryStore.loadBooks()
        #expect(libraryStore.savedBooks == fakeLibraryStorage.savedBooks)
        try libraryStore.deleteBook(key: completed.key)
        let expectedBooks = [wantToRead]
        #expect(libraryStore.savedBooks == expectedBooks)
    }
    
    @Test func changeStatusUpdatesSavedBookStatus() throws {
        let fakeLibraryStorage = FakeLibraryStorage()
        let book = makeBook(key: "wantToRead", status: .wantToRead)
        fakeLibraryStorage.savedBooks = [book]
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        try libraryStore.loadBooks()
        #expect(libraryStore.savedBooks.first?.status == .wantToRead)
        try libraryStore.changeStatus(key: book.key, status: .completed)
        #expect(libraryStore.savedBooks.first?.status == .completed)
        #expect(libraryStore.savedBooks.count == 1)
        #expect(libraryStore.savedBooks.first?.key == book.key)
    }
    
    @Test func loadBooksThrowsWhenStorageFails() {
        let fakeLibraryStorage = FakeLibraryStorage()
        let error: TestError = .loadingFailed
        fakeLibraryStorage.error = error
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        #expect(throws: TestError.self) {
            try libraryStore.loadBooks()
        }
    }
    
    @Test func addBookThrowsWhenStorageFails() {
        let fakeLibraryStorage = FakeLibraryStorage()
        let error: TestError = .savingFailed
        fakeLibraryStorage.saveError = error
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        let book = makeBook(key: "book", status: .wantToRead)
        #expect(throws: TestError.self) {
            try libraryStore.addBook(book)
        }
    }
    
    @Test func deleteBookThrowsWhenStorageFails() {
        let fakeLibraryStorage = FakeLibraryStorage()
        let error: TestError = .deletionFailed
        fakeLibraryStorage.error = error
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        let book = makeBook(key: "book", status: .wantToRead)
        #expect(throws: TestError.self) {
            try libraryStore.deleteBook(key: book.key)
        }
    }
    
    @Test func changeStatusThrowsWhenStorageFails() {
        let fakeLibraryStorage = FakeLibraryStorage()
        let error: TestError = .statusChangeFailed
        fakeLibraryStorage.error = error
        let libraryStore = LibraryStore(libraryStorage: fakeLibraryStorage)
        let book = makeBook(key: "book", status: .wantToRead)
        #expect(throws: TestError.self) {
            try libraryStore.changeStatus(key: book.key, status: .completed)
        }
    }
}
