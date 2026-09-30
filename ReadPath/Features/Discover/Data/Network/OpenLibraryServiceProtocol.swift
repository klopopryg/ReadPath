//
//  OpenLibraryServiceProtocol.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

protocol OpenLibraryServiceProtocol {
    func fetchBooks(query: String, page: Int, limit: Int) async throws -> SearchBooksResponseDTO
}
