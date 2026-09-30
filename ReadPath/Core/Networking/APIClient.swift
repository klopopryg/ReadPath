//
//  APIClient.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import Foundation

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func request<T>(endpoint: EndpointProtocol) async throws -> T where T : Decodable {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard(200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
