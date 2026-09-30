//
//  ImageLoader.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import UIKit

final class ImageLoader: ImageLoaderProtocol {
    func loadImageFrom(url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResposnse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard(200...299).contains(httpResposnse.statusCode) else {
            throw NetworkError.badStatusCode(httpResposnse.statusCode)
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidResponse
        }
        
        return image
    }
}
