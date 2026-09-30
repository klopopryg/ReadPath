//
//  APIClientProtocol.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

protocol APIClientProtocol {
    func request<T:Decodable>(endpoint: EndpointProtocol) async throws -> T
}
