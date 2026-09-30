//
//  OpenLibraryService.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

final class OpenLibraryService: OpenLibraryServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchBooks(query: String, page: Int, limit: Int) async throws -> SearchBooksResponseDTO {
        let endpoint = BooksEndpoint.search(query: query, page: page, limit: limit)
        return try await apiClient.request(endpoint: endpoint)
    }
}
