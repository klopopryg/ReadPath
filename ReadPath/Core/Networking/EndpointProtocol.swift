//
//  EndpointProtocol.swift
//  ReadPath
//
//  Created by Егор on 29.09.2026.
//

import Foundation

protocol EndpointProtocol {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: HTTPMethod { get }
}
