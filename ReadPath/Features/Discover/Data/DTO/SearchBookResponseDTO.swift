//
//  SearchBookResponseDTO.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

struct SearchBooksResponseDTO: Decodable {
    let numFound: Int
    let docs: [BookDTO]
}

struct BookDTO: Decodable, Equatable {
    let authorName: [String]?
    let firstPublishYear: Int?
    let coverID: Int?
    let key: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverID = "cover_i"
        case key
        case title
    }
}
