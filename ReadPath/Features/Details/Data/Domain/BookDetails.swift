//
//  Details.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import Foundation

struct BookDetails {
    let title: String
    let id: String
    let description: String?
    let coverURL: URL?
    let subjects: [String]?
}

extension BookDetails {
    init(dto: BookDetailsResponseDTO) {
        self.init(
            title: dto.title,
            id: dto.key,
            description: dto.description?.value,
            coverURL: CoverURLBuilder.makeCoverURL(
                coverID: dto.covers?.first, size: CoverSize.large
            ),
            subjects: dto.subjects
        )
    }
}
