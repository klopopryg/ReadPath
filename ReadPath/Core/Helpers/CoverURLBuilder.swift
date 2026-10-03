//
//  CoverURLBuilder.swift
//  ReadPath
//
//  Created by Егор on 03.10.2026.
//

import Foundation

enum CoverSize: String {
    case small = "S"
    case meduim = "M"
    case large = "L"
}

enum CoverURLBuilder {
    static func makeCoverURL(coverID: Int?, size: CoverSize) -> URL? {
        guard let coverID else { return nil }
        let url = URL(
            string: "https://covers.openlibrary.org/b/id/\(coverID)-\(size.rawValue).jpg"
        )
        return url
    }
}
