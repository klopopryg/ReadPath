//
//  BookDetailsServiceProtocol.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

protocol BookDetailsServiceProtocol {
    func fetchDetails(key: String) async throws -> BookDetailsResponseDTO
}
