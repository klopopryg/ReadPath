//
//  FakeBookDetailsRepository.swift
//  ReadPath
//
//  Created by Егор on 20.10.2026.
//

@testable import ReadPath

final class FakeBookDetailsRepository: BookDetailsRepositoryProtocol {
    private let bookDetails: BookDetails?
    
    init(bookDetails: BookDetails?) {
        self.bookDetails = bookDetails
    }
    
    func loadDetails(key: String) async throws -> ReadPath.BookDetails {
        guard let bookDetails else {
            throw TestError.loadingFailed
        }
        
        return bookDetails
    }
}
