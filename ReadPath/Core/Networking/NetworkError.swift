//
//  NetworkError.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
}
