//
//  BookDetailsRepository.swift
//  ReadPath
//
//  Created by Егор on 03.10.2026.
//

final class BookDetailsRepository: BookDetailsRepositoryProtocol {
    private let service: BookDetailsServiceProtocol
    
    init(service: BookDetailsServiceProtocol) {
        self.service = service
    }
    
    func loadDetails(key: String) async throws -> BookDetails {
        let result = try await service.fetchDetails(key: key)
        return BookDetails(dto: result)
    }
}
