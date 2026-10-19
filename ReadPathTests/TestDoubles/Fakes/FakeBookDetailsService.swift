//
//  FakeBookDetailsService.swift
//  ReadPath
//
//  Created by Егор on 19.10.2026.
//

@testable import ReadPath

final class FakeBookDetailsService: BookDetailsServiceProtocol {
    private var bookDetailsResponseDTO: BookDetailsResponseDTO?
    private(set) var key = ""
    
    init(bookDetailsResponseDTO: BookDetailsResponseDTO?) {
        self.bookDetailsResponseDTO = bookDetailsResponseDTO
    }
    
    func fetchDetails(key: String) async throws -> ReadPath.BookDetailsResponseDTO {
        self.key = key
        guard let bookDetailsResponseDTO else {
            throw TestError.loadingFailed
        }
        
        return bookDetailsResponseDTO
    }
}
