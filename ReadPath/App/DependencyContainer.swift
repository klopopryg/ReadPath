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
    private let imageloader: ImageLoaderProtocol
    
    init() {
        guard let baseURL = URL(string: "https://openlibrary.org") else {
            preconditionFailure("Invalid Open Library base URL")
        }
        let apiClient = APIClient(baseURL: baseURL)
        let service = OpenLibraryService(apiClient: apiClient)
        let repository = BooksRepository(openLibraryService: service)
        let imageLoader = ImageLoader()
        
        self.apiClient = apiClient
        self.openLibraryService = service
        self.booksRepository = repository
        self.imageloader = imageLoader
    }
    
    func makeDiscoverViewController() -> UIViewController {
        let discoverViewModel = DiscoverViewModel(booksRepository: booksRepository)
        let discoverViewController = DiscoverViewController(
            discoverViewModel: discoverViewModel, imageLoader: imageloader
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
