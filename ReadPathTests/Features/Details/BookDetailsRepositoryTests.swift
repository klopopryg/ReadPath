//
//  BookDetailsRepositoryTests.swift
//  ReadPath
//
//  Created by Егор on 19.10.2026.
//

import Testing
@testable import ReadPath
import Foundation

@MainActor
final class BookDetailsRepositoryTests {
    @Test func loadDetailsReturnsMappedBookDetails() async throws {
        let bookDetailsResponseDTO = BookDetailsResponseDTO(
            title: "book",
            key: "book",
            description: .text("Book description"),
            covers: [123],
            subjects: ["Fantasy"]
        )
        let fakeBookDetailsService = FakeBookDetailsService(
            bookDetailsResponseDTO: bookDetailsResponseDTO
        )
        let bookDetailsRepository = BookDetailsRepository(service: fakeBookDetailsService)
        let loadedBookDetails = try await bookDetailsRepository.loadDetails(key: bookDetailsResponseDTO.key)
        let expectedBookDetails = BookDetails(
            title: "book",
            id: "book",
            description: "Book description",
            coverID: 123,
            coverURL: URL(string: "https://covers.openlibrary.org/b/id/123-L.jpg"),
            subjects: ["Fantasy"]
        )
        #expect(loadedBookDetails == expectedBookDetails)
    }
    
    @Test func loadDetailsThrowsWhenServiceFails() async throws {
        let fakeBookDetailsService = FakeBookDetailsService(bookDetailsResponseDTO: nil)
        let bookDetailsRepository = BookDetailsRepository(service: fakeBookDetailsService)
        await #expect(throws: TestError.self) {
            try await bookDetailsRepository.loadDetails(key: "key")
        }
    }
    
    @Test func loadDetailsPassesKeyToService() async throws {
        let bookDetailsResponseDTO = BookDetailsResponseDTO(
            title: "book",
            key: "book",
            description: nil,
            covers: nil,
            subjects: nil
        )
        let fakeBookDetailsService = FakeBookDetailsService(bookDetailsResponseDTO: bookDetailsResponseDTO)
        let bookDetailsRepository = BookDetailsRepository(service: fakeBookDetailsService)
        _ = try await bookDetailsRepository.loadDetails(key: "key")
        #expect(fakeBookDetailsService.key == "key")
    }
}
