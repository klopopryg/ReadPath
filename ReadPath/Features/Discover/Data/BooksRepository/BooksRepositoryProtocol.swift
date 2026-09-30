//
//  BooksRepositoryProtocol.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

protocol BooksRepositoryProtocol {
    func loadBooks(query: String, page: Int, limit: Int) async throws -> BooksPage
}
