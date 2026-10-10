//
//  BookDetailsViewModel.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import Foundation

final class BookDetailsViewModel {
    private let repository: BookDetailsRepositoryProtocol
    private let libraryStore: LibraryStoreProtocol
    private let key: String
    private var bookDetails: BookDetails?
    var onStateChanged: ((DetailsState) -> Void)?
    var onLibraryAction: ((LibraryActionResult) -> Void)?
    
    
    init(repository: BookDetailsRepositoryProtocol, key: String, libraryStore: LibraryStoreProtocol) {
        self.repository = repository
        self.key = key
        self.libraryStore = libraryStore
    }
    
    func loadDetails() {
        onStateChanged?(.loading)
        Task {
            do {
                let details = try await repository.loadDetails(key: key)
                bookDetails = details
                onStateChanged?(.loaded(details))
            } catch {
                onStateChanged?(.error(error.localizedDescription))
            }
            
            do {
                let isInLibrary = try libraryStore.containsBook(key: key)
                onLibraryAction?(.memberShipChanged(isInLibrary: isInLibrary))
            } catch {
                onLibraryAction?(.error(error.localizedDescription))
            }
        }
    }
    
    func toggleLibraryMemberShip() {
        do {
            if try libraryStore.containsBook(key: key) {
                try libraryStore.deleteBook(key: key)
                onLibraryAction?(.memberShipChanged(isInLibrary: false))
            } else {
                guard let bookDetails else { return }
                let book = SavedBook(
                    key: bookDetails.id,
                    title: bookDetails.title,
                    coverID: bookDetails.coverID,
                    status: .wantToRead,
                    addedAt: Date())
                try libraryStore.addBook(book)
                onLibraryAction?(.memberShipChanged(isInLibrary: true))
            }
        } catch {
            onLibraryAction?(.error(error.localizedDescription))
        }
    }
}
