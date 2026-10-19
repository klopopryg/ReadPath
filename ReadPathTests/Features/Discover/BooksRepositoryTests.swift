//
//  BooksRepositoryTests.swift
//  ReadPath
//
//  Created by Егор on 19.10.2026.
//

import Testing
@testable import ReadPath

@MainActor
final class BooksRepositoryTests {
    @Test func loadBooksReturnsMappedBooksPage() async throws {
        let searchBookResponseDTO = SearchBooksResponseDTO(
            numFound: 20,
            docs: [BookDTO(
                authorName: nil,
                firstPublishYear: nil,
                coverID: nil,
                key: "book",
                title: "book")]
        )
        let fakeLibraryService = FakeLibraryService(
            searchBooksResponseDTO: searchBookResponseDTO
        )
        let booksRepository = BooksRepository(openLibraryService: fakeLibraryService)
        let booksPage = try await booksRepository.loadBooks(query: "Dune", page: 1, limit: 1)
        let expectedBooksPage = BooksPage(
            books: [Book(
                authorName: nil,
                firstPublishYear: nil,
                coverURL: nil,
                key: "book",
                title: "book")],
            total: 20
        )
        #expect(booksPage == expectedBooksPage)
    }
    
    @Test func loadBooksThrowsWhenServiceFailes() async {
        let fakeLibraryService = FakeLibraryService(searchBooksResponseDTO: nil)
        let booksRepository = BooksRepository(openLibraryService: fakeLibraryService)
        await #expect(throws: TestError.self) {
            try await booksRepository.loadBooks(query: "Dune", page: 1, limit: 1)
        }
    }
    
    @Test func loadBooksPassesParametersToService() async throws {
        let searchBookResponseDTO = SearchBooksResponseDTO(
            numFound: 20,
            docs: [BookDTO(
                authorName: nil,
                firstPublishYear: nil,
                coverID: nil,
                key: "book",
                title: "book")]
        )
        let fakeLibraryService = FakeLibraryService(searchBooksResponseDTO: searchBookResponseDTO)
        let booksRepository = BooksRepository(openLibraryService: fakeLibraryService)
        _ = try await booksRepository.loadBooks(query: "Dune", page: 1, limit: 1)
        #expect(fakeLibraryService.query == "Dune")
        #expect(fakeLibraryService.page == 1)
        #expect(fakeLibraryService.limit == 1)
    }
}
