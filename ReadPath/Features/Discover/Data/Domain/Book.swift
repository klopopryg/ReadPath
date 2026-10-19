//
//  DomainSearchBooks.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import Foundation

struct BooksPage: Equatable {
    let books: [Book]
    let total: Int
}

struct Book: Equatable {
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

extension Book {
    init(dto: BookDTO) {
        self.init(
            authorName: dto.authorName,
            firstPublishYear: dto.firstPublishYear,
            coverURL: CoverURLBuilder.makeCoverURL(
                coverID: dto.coverID, size: CoverSize.medium
            ),
            key: dto.key,
            title: dto.title
        )
    }
    
}
