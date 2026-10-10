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
}
