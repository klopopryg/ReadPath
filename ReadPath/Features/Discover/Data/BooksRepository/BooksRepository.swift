//
//  BooksRepository.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

final class BooksRepository: BooksRepositoryProtocol {
    private let openLibraryService: OpenLibraryServiceProtocol
    
    init(openLibraryService: OpenLibraryServiceProtocol) {
        self.openLibraryService = openLibraryService
    }
    
    func loadBooks(query: String, page: Int, limit: Int) async throws -> BooksPage {
        let result = try await openLibraryService.fetchBooks(query: query, page: page, limit: limit)
        return BooksPage(dto: result)
    }
}
