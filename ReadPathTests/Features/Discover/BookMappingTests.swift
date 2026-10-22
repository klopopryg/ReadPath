//
//  BookMappingTests.swift
//  ReadPath
//
//  Created by Егор on 17.10.2026.
//

import Testing
@testable import ReadPath
import Foundation

@MainActor
final class BookMappingTests {
    
    @Test func mapsBookDTOToBook() {
        let dto = BookDTO(
            authorName: ["name"],
            firstPublishYear: 1,
            coverID: 2,
            key: "dto",
            title: "dto"
        )
        let mappedDTO = Book(dto: dto)
        let expectedMappedDTO = Book(
            authorName: ["name"],
            firstPublishYear: 1,
            coverURL: URL(string: "https://covers.openlibrary.org/b/id/2-M.jpg"),
            key: "dto",
            title: "dto"
        )
        #expect(mappedDTO == expectedMappedDTO)
    }
    
    @Test func mapsBookDTOWithMissingOptionalFields() {
        let dto = BookDTO(
            authorName: nil,
            firstPublishYear: nil,
            coverID: nil,
            key: "dto",
            title: "dto"
        )
        let mappedDTO = Book(dto: dto)
        let expectedMappedDTO = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "dto",
            title: "dto"
        )
        #expect(mappedDTO == expectedMappedDTO)
    }
    
    @Test func mapsSearchBookResponseDTOToBooksPage() {
        let firstBookDTO = BookDTO(
            authorName: nil,
            firstPublishYear: nil,
            coverID: nil,
            key: "firstBook",
            title: "firstBook"
        )
        let secondBookDTO = BookDTO(
            authorName: nil,
            firstPublishYear: nil,
            coverID: nil,
            key: "secondBook",
            title: "secondBook"
        )
        let responseDTO = SearchBooksResponseDTO(numFound: 20, docs: [firstBookDTO, secondBookDTO])
        let page = BooksPage(dto: responseDTO)
        let expectedMappedBooks = [
            Book(
                authorName: nil,
                firstPublishYear: nil,
                coverURL: nil,
                key: "firstBook",
                title: "firstBook"
            ),
            Book(
                authorName: nil,
                firstPublishYear: nil,
                coverURL: nil,
                key: "secondBook",
                title: "secondBook"
            )
            
        ]
        #expect(page.total == 20)
        #expect(page.books == expectedMappedBooks)
    }
}
