//
//  DiscoverViewModel.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import Foundation

@MainActor
final class DiscoverViewModel {
    private let booksRepository: BooksRepositoryProtocol
    private var loadedPage: BooksPage?
    private(set) var books: [Book] = []
    var onStateChanged: ((DiscoverState) -> Void)?
    
    init(booksRepository: BooksRepositoryProtocol) {
        self.booksRepository = booksRepository
    }
    
    func search(query: String?) {
        guard let query = query else { return }
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        onStateChanged?(.loading)
        Task {
            do {
                let searchPage = try await booksRepository.loadBooks(query: trimmedQuery, page: 1, limit: 30)
                loadedPage = searchPage
                books = searchPage.books
                if !books.isEmpty {
                    onStateChanged?(.loaded)
                } else {
                    onStateChanged?(.empty(query))
                }
            } catch {
                onStateChanged?(.error(error.localizedDescription))
            }
        }
    }
    
    func getBooksCount() -> Int {
        books.count
    }
}
