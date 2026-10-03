//
//  BookDetailsRepositoryProtocol.swift
//  ReadPath
//
//  Created by Егор on 03.10.2026.
//

protocol BookDetailsRepositoryProtocol {
    func loadDetails(key: String) async throws -> BookDetails
}
