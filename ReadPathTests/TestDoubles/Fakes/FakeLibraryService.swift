//
//  FakeBooksService.swift
//  ReadPath
//
//  Created by Егор on 19.10.2026.
//

@testable import ReadPath

final class FakeLibraryService: OpenLibraryServiceProtocol {
    private let searchBooksResponseDTO: SearchBooksResponseDTO?
    private(set) var query = ""
    private(set) var page = 0
    private(set) var limit = 0
    
    init(searchBooksResponseDTO: SearchBooksResponseDTO?) {
        self.searchBooksResponseDTO = searchBooksResponseDTO
    }
    
    func fetchBooks(query: String, page: Int, limit: Int) async throws -> ReadPath.SearchBooksResponseDTO {
        self.query = query
        self.page = page
        self.limit = limit
        guard let searchBooksResponseDTO else {
            throw TestError.loadingFailed
        }
        
        return searchBooksResponseDTO
    }
}
