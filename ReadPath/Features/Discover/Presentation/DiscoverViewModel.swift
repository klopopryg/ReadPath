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
    private var currentQuery: String?
    private var currentPage = 0
    private var total = 0
    private var pageSize = 20
    private var hasMorePages: Bool {
        books.count < total
    }
    private var isLoadingMore = false
    private(set) var books: [Book] = []
    private var searchID = UUID()
    private var searchTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?
    var onStateChanged: ((DiscoverState) -> Void)?
    
    init(booksRepository: BooksRepositoryProtocol) {
        self.booksRepository = booksRepository
    }
    
    func loadNextPage() {
        guard let query = currentQuery, !isLoadingMore, hasMorePages else { return }
        let requestSearchID = searchID
        let nextPageNumber = currentPage + 1
        isLoadingMore = true
        onStateChanged?(.loadingMore)
        paginationTask = Task {
            defer {
                if requestSearchID == searchID {
                    isLoadingMore = false
                }
            }
            do {
                let loadedNextPage = try await booksRepository.loadBooks(
                    query: query,
                    page: nextPageNumber,
                    limit: pageSize
                )
                guard !Task.isCancelled else { return }
                let oldCount = books.count
                books.append(contentsOf: loadedNextPage.books)
                let newCount = books.count
                currentPage = nextPageNumber
                total = loadedNextPage.total
                onStateChanged?(.loadedNextPage(oldCount..<newCount))
            } catch {
                guard !Task.isCancelled else { return }
                onStateChanged?(.nextPageError(error.localizedDescription))
            }
        }
    }
    
    @discardableResult
    func search(query: String?) -> Task<Void, Never>? {
        guard let query = query else { return nil }
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return nil }
        searchID = UUID()
        searchTask?.cancel()
        paginationTask?.cancel()
        currentQuery = trimmedQuery
        currentPage = 0
        total = 0
        books = []
        isLoadingMore = false
        onStateChanged?(.loading)
        searchTask = Task {
            do {
                let loadedFirstPage = try await booksRepository.loadBooks(
                    query: trimmedQuery,
                    page: 1,
                    limit: pageSize
                )
                guard !Task.isCancelled else { return }
                currentPage = 1
                books = loadedFirstPage.books
                total = loadedFirstPage.total
                if !books.isEmpty {
                    onStateChanged?(.loaded)
                } else {
                    onStateChanged?(.empty(trimmedQuery))
                }
            } catch {
                guard !Task.isCancelled else { return }
                onStateChanged?(.loadingError(error.localizedDescription))
            }
        }
        return searchTask
    }
    
    func getBooksCount() -> Int {
        books.count
    }
    
    func getBookAt(index: Int) -> Book {
        books[index]
    }
}
