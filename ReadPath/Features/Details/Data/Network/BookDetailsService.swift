//
//  BookDetailsService.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

final class BookDetailsService: BookDetailsServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchDetails(key: String) async throws -> BookDetailsResponseDTO {
        let endpoint = BooksEndpoint.details(key: key)
        return try await apiClient.request(endpoint: endpoint)
    }
}
