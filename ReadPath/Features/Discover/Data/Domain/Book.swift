//
//  DomainSearchBooks.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import Foundation

struct BooksPage {
    let books: [Book]
    let total: Int
}

struct Book {
    let authorName: [String]?
    let firstPublishYear: Int?
    let coverURL: URL?
    let key: String
    let title: String
}

extension BooksPage {
    init(dto: SearchBooksResponseDTO) {
        self.init(books: dto.docs.map { Book(dto: $0) }, total: dto.numFound)
    }
}

func makeCoverURL(coverID: Int?) -> URL? {
    guard let coverID else { return nil }
    let url = URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg")
    return url
}

extension Book {
    init(dto: BookDTO) {
        self.init(
            authorName: dto.authorName,
            firstPublishYear: dto.firstPublishYear,
            coverURL: makeCoverURL(coverID: dto.coverID),
            key: dto.key,
            title: dto.title
        )
    }
    
}
