//
//  StatisticsViewModel.swift
//  ReadPath
//
//  Created by Егор on 12.10.2026.
//

import Foundation
import Observation

@Observable
final class StatisticsViewModel {
    private let libraryStore: LibraryStoreProtocol
    private(set) var totalBooksCount = 0
    private(set) var wantToReadBooksCount = 0
    private(set) var readingBooksCount = 0
    private(set) var completedBooksCount = 0
    private(set) var errorMassage: String?
    
    init(libraryStore: LibraryStoreProtocol) {
        self.libraryStore = libraryStore
    }
    
    func refreshStatistics() {
        do {
           try libraryStore.loadBooks()
            updateTotalBooksCount()
            updateWantToReadBooksCount()
            updateReadingBooksCount()
            updateCompletedBooksCount()
            errorMassage = nil
        } catch {
            errorMassage = error.localizedDescription
        }
    }
    
    private func updateTotalBooksCount() {
        totalBooksCount = libraryStore.savedBooks.count
    }
    
    private func updateWantToReadBooksCount() {
        wantToReadBooksCount = filterBooks(.wantToRead).count
    }
    
    private func updateReadingBooksCount() {
        readingBooksCount = filterBooks(.reading).count
    }
    
    private func updateCompletedBooksCount() {
        completedBooksCount = filterBooks(.completed).count
    }
    
    private func filterBooks(_ status: ReadingStatus) -> [SavedBook] {
        libraryStore.savedBooks.filter { book in
            book.status == status
        }
    }
}
