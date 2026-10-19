//
//  Details.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import Foundation

struct BookDetails: Equatable {
    let title: String
    let id: String
    let description: String?
    let coverID: Int?
    let coverURL: URL?
    let subjects: [String]?
}

extension BookDetails {
    init(dto: BookDetailsResponseDTO) {
        self.init(
            title: dto.title,
            id: dto.key,
            description: dto.description?.value,
            coverID: dto.covers?.first,
            coverURL: CoverURLBuilder.makeCoverURL(
                coverID: dto.covers?.first, size: CoverSize.large
            ),
            subjects: dto.subjects
        )
    }
}
