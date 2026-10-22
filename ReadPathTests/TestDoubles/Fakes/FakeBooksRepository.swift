//
//  FakeBooksRepository.swift
//  ReadPath
//
//  Created by Егор on 20.10.2026.
//

@testable import ReadPath

final class FakeBooksRepository: BooksRepositoryProtocol {
    private var pages: [Int: BooksPage] = [:]
    private var pendingResponse: CheckedContinuation<BooksPage, Error>?
    private(set) var requestedPages: [Int] = []
    var pageToSuspend: Int?
    var queryToSuspend: String?
    var onRequestSuspended: (() -> Void)?
    
    init(pages: [Int: BooksPage]) {
        self.pages = pages
    }
    
    func loadBooks(query: String, page: Int, limit: Int) async throws -> ReadPath.BooksPage {
        requestedPages.append(page)
        
        if page == pageToSuspend && (queryToSuspend == nil || query == queryToSuspend) {
            return try await withCheckedThrowingContinuation { continuation in
                pendingResponse = continuation
                onRequestSuspended?()
            }
        }
        
        guard let booksPage = pages[page] else {
            throw TestError.loadingFailed
        }
        
        return booksPage
    }
    
    func completePendingRequestWithPage(_ page: BooksPage) {
        let continuation = pendingResponse
        pendingResponse = nil
        continuation?.resume(returning: page)
    }
}
