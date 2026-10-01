//
//  DependencyContainer.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

final class DependencyContainer {
    private let apiClient: APIClientProtocol
    private let openLibraryService: OpenLibraryServiceProtocol
    private let booksRepository: BooksRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol
    
    init() {
        guard let baseURL = URL(string: "https://openlibrary.org") else {
            preconditionFailure("Invalid Open Library base URL")
        }
        let apiClient = APIClient(baseURL: baseURL)
        let service = OpenLibraryService(apiClient: apiClient)
        let repository = BooksRepository(openLibraryService: service)
        let cache: [String: UIImage] = [:]
        let imageLoader = ImageLoader(cache: cache)
        
        self.apiClient = apiClient
        self.openLibraryService = service
        self.booksRepository = repository
        self.imageLoader = imageLoader
    }
    
    func makeDiscoverViewController() -> UIViewController {
        let discoverViewModel = DiscoverViewModel(booksRepository: booksRepository)
        let discoverViewController = DiscoverViewController(
            discoverViewModel: discoverViewModel, imageLoader: imageLoader
        )
        discoverViewController.title = "Discover"
        discoverViewController.view.backgroundColor = .systemBackground
        return discoverViewController
    }
    
    func makeLibraryViewController() -> UIViewController {
        let libraryViewController = LibraryViewController()
        libraryViewController.title = "Library"
        libraryViewController.view.backgroundColor = .systemBackground
        return libraryViewController
    }
    
    func makeStatisticsViewController() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.title = "Statistics"
        statisticsViewController.view.backgroundColor = .systemBackground
        return statisticsViewController
    }
}
