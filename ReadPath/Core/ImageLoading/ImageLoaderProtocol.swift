//
//  ImageLoaderProtocol.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImageFrom(url: URL) async throws -> UIImage
}
