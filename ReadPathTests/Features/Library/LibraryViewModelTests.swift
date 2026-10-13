//
//  LibraryViewModelTests.swift
//  ReadPath
//
//  Created by Егор on 12.10.2026.
//

import Foundation
import Testing
@testable import ReadPath

final class LibraryViewModelTests {
    
    @Test func setFilterAllDisplaysAllSavedBooks() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.all)
        let expectedBooks = [wantToRead, readingFirst, readingSecond, completed]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func setFilterWantToReadDisplaysWantToReadSavedBooks() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.wantToRead)
        let expectedBooks = [wantToRead]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func setFilterReadingDisplaysReadingSavedBooks() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.reading)
        let expectedBooks = [readingFirst, readingSecond]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func setFilterCompletedDisplaysCompletedSavedBooks() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.completed)
        let expectedBooks = [completed]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func loadBooksPreservesSelectedFilter() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.reading)
        fakeLibraryStore.savedBooks.removeAll { book in
            book.key == readingSecond.key
        }
        viewModel.loadBooks()
        let expectedBooks = [readingFirst]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func deleteBookUpdatesDisplayedBooksAndPreservesFilter() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.reading)
        let displayedBooks = [readingFirst, readingSecond]
        #expect(viewModel.displayedBooks == displayedBooks)
        let deleted = viewModel.deleteBook(key: readingSecond.key)
        #expect(deleted)
        let expectedBooks = [readingFirst]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func changeStatusRemovesBookFromDisplayedBooksWhenItNoLongerMatchesFilter() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "readingFirst", status: .reading)
        let readingSecond = makeBook(key: "readingSecond", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.reading)
        let displayedBooks = [readingFirst, readingSecond]
        #expect(viewModel.displayedBooks == displayedBooks)
        viewModel.changeStatus(key: readingSecond.key, status: .completed)
        let expectedBooks = [readingFirst]
        #expect(viewModel.displayedBooks == expectedBooks)
    }
    
    @Test func changeStatusSendsChangedStateWhenFilterIsAll() {
        var receivedState: SavedBookState?
        let fakeLibraryStore = FakeLibraryStore()
        let book = makeBook(key: "book", status: .wantToRead)
        fakeLibraryStore.savedBooks = [book]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.all)
        viewModel.onStateChanged = { state in
            receivedState = state
        }
        viewModel.changeStatus(key: book.key, status: .completed)
        switch receivedState {
        case .changed(key: let key):
            #expect(book.key == key)
        default:
            Issue.record("Expected changed state")
        }
    }
    
    @Test func changeStatusSendsLoadedStateWhenFilterIsReading() {
        var receivedState: SavedBookState?
        let fakeLibraryStore = FakeLibraryStore()
        let book = makeBook(key: "book", status: .reading)
        fakeLibraryStore.savedBooks = [book]
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.setFilter(.reading)
        viewModel.onStateChanged = { state in
            receivedState = state
        }
        viewModel.changeStatus(key: book.key, status: .completed)
        switch receivedState {
        case .loaded:
            break
        default:
            Issue.record("Expected loaded state")
        }
    }
    
    @Test func deleteBookReturnsFalseAndSendsErrorStateWhenStoreFails() {
        var receivedState: SavedBookState?
        let fakeLibraryStore = FakeLibraryStore()
        let book = makeBook(key: "book", status: .wantToRead)
        fakeLibraryStore.savedBooks = [book]
        let error: TestError = .deletionFailed
        fakeLibraryStore.error = error
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.onStateChanged = { state in
                receivedState = state
        }
        let result = viewModel.deleteBook(key: book.key)
        #expect(result == false)
        switch receivedState {
        case .error(let message):
            #expect(error.localizedDescription == message)
        default:
            Issue.record("Expected error state")
        }
    }
    
    @Test func changeStatusSendsErrorStateWhenStoreFails() {
        var receivedState: SavedBookState?
        let fakeLibraryStore = FakeLibraryStore()
        let book = makeBook(key: "book", status: .wantToRead)
        fakeLibraryStore.savedBooks = [book]
        let error: TestError = .statusChangeFailed
        fakeLibraryStore.error = error
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.onStateChanged = { state in
                receivedState = state
        }
        viewModel.changeStatus(key: book.key, status: .completed)
        switch receivedState {
        case .error(let message):
            #expect(error.localizedDescription == message)
        default:
            Issue.record("Expected error state")
        }
    }
    
    @Test func loadBooksSendsErrorStateWhenStoreFails() {
        var receivedState: SavedBookState?
        let fakeLibraryStore = FakeLibraryStore()
        let error: TestError = .loadingFailed
        fakeLibraryStore.error = error
        let viewModel = LibraryViewModel(libraryStore: fakeLibraryStore)
        viewModel.onStateChanged = { state in
                receivedState = state
        }
        viewModel.loadBooks()
        switch receivedState {
        case .error(let message):
            #expect(error.localizedDescription == message)
        default:
            Issue.record("Expected error state")
        }
    }
}
