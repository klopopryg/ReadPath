//
//  BooksEndpoint.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import Foundation

enum BooksEndpoint: EndpointProtocol {
    case search(query: String, page: Int, limit: Int)
    case details(key: String)
    
    var path: String {
        switch self {
        case .search:
            let path = "/search.json"
            return path
        case .details(let key):
            let path = "\(key).json"
            return path
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query, let page, let limit):
            let queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "fields", value: "key,title,author_name,first_publish_year,cover_i")
            ]
            return queryItems
        case .details:
            let queryItems: [URLQueryItem] = []
            return queryItems
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .search, .details:
            let httpMethod: HTTPMethod = .get
            return httpMethod
        }
    }
}
