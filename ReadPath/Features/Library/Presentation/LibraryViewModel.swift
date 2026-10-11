//
//  LibraryViewModel.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

import Foundation

final class LibraryViewModel {
    private let libraryStore: LibraryStoreProtocol
    private(set) var displayedBooks: [SavedBook] = []
    private var currentFilter: LibraryFilter = .all
    var onStateChanged: ((SavedBookState) -> Void)?
    
    init(libraryStore: LibraryStoreProtocol) {
        self.libraryStore = libraryStore
    }
    
    func getBookIndexAtKey(_ key: String) -> Int? {
        displayedBooks.firstIndex { savedBook in
            savedBook.key == key
        }
    }
    
    func loadBooks() {
        do {
            try libraryStore.loadBooks()
            updateDisplayedBooks()
            onStateChanged?(.loaded)
        } catch {
            onStateChanged?(.error(error.localizedDescription))
        }
    }
    
    func deleteBook(key: String) -> Bool {
        do {
            try libraryStore.deleteBook(key: key)
            updateDisplayedBooks()
            onStateChanged?(.loaded)
            return true
        } catch {
            onStateChanged?(.error(error.localizedDescription))
            return false
        }
    }
    
    func changeStatus(key: String, status: ReadingStatus) {
        do {
            try libraryStore.changeStatus(key: key, status: status)
            updateDisplayedBooks()
            if currentFilter == .all {
                onStateChanged?(.changed(key: key))
            } else {
                onStateChanged?(.loaded)
            }
        } catch {
            onStateChanged?(.error(error.localizedDescription))
        }
    }
    
    func setFilter(_ filter: LibraryFilter) {
        currentFilter = filter
        updateDisplayedBooks()
        onStateChanged?(.loaded)
    }
    
    private func updateDisplayedBooks() {
        switch currentFilter {
        case .all:
            displayedBooks = libraryStore.savedBooks
        case .wantToRead:
            filterBooks(.wantToRead)
        case .reading:
            filterBooks(.reading)
        case .completed:
            filterBooks(.completed)
        }
    }
    
    private func filterBooks(_ status: ReadingStatus) {
        let filteredBooks = libraryStore.savedBooks.filter { book in
            book.status == status
        }
        displayedBooks = filteredBooks
    }
}
