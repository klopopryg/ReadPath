//
//  LibraryViewModel.swift
//  ReadPath
//
//  Created by Егор on 04.10.2026.
//

import Foundation

final class LibraryViewModel {
    private let libraryStore: LibraryStoreProtocol
    var onStateChanged: ((SavedBookState) -> Void)?
    
    init(libraryStore: LibraryStoreProtocol) {
        self.libraryStore = libraryStore
    }
    
    func getSavedBooksCount() -> Int {
        libraryStore.getSavedBooksCount()
    }
    
    func getBookAtIndex(_ index: Int) -> SavedBook {
        libraryStore.getBookAtIndex(index)
    }
    
    func getBookIndexAtKey(_ key: String) -> Int? {
        libraryStore.savedBooks.firstIndex { savedBook in
            savedBook.key == key
        }
    }
    
    func loadBooks() {
        do {
            try libraryStore.loadBooks()
            onStateChanged?(.loaded)
        } catch {
            onStateChanged?(.error(error.localizedDescription))
        }
    }
    
    func deleteBook(key: String) -> Bool {
        do {
            try libraryStore.deleteBook(key: key)
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
            onStateChanged?(.changed(key: key))
        } catch {
            onStateChanged?(.error(error.localizedDescription))
        }
    }
}
