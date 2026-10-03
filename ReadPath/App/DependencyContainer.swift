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
    private let bookDetailsService: BookDetailsServiceProtocol
    private let booksRepository: BooksRepositoryProtocol
    private let bookDetailsRepository: BookDetailsRepositoryProtocol
    private let imageLoader: ImageLoaderProtocol
    
    init() {
        guard let baseURL = URL(string: "https://openlibrary.org") else {
            preconditionFailure("Invalid Open Library base URL")
        }
        let apiClient = APIClient(baseURL: baseURL)
        let openLibraryService = OpenLibraryService(apiClient: apiClient)
        let bookDetailsService = BookDetailsService(apiClient: apiClient)
        let booksRepository = BooksRepository(openLibraryService: openLibraryService)
        let bookDetailsRepository = BookDetailsRepository(service: bookDetailsService)
        let cache: [String: UIImage] = [:]
        let imageLoader = ImageLoader(cache: cache)
        
        self.apiClient = apiClient
        self.openLibraryService = openLibraryService
        self.bookDetailsService = bookDetailsService
        self.booksRepository = booksRepository
        self.bookDetailsRepository = bookDetailsRepository
        self.imageLoader = imageLoader
    }
    
    func makeDiscoverViewController() -> DiscoverViewController {
        let discoverViewModel = DiscoverViewModel(booksRepository: booksRepository)
        let discoverViewController = DiscoverViewController(
            discoverViewModel: discoverViewModel, imageLoader: imageLoader
        )
        
        discoverViewController.title = "Discover"
        discoverViewController.view.backgroundColor = .systemBackground
        return discoverViewController
    }
    
    func makeLibraryViewController() -> LibraryViewController {
        let libraryViewController = LibraryViewController()
        libraryViewController.title = "Library"
        libraryViewController.view.backgroundColor = .systemBackground
        return libraryViewController
    }
    
    func makeDetailsViewController(key: String) -> BookDetailsViewController {
        let bookDetailsViewModel = BookDetailsViewModel(repository: bookDetailsRepository, key: key)
        let bookDetailsViewController = BookDetailsViewController(
            bookDetailsViewModel: bookDetailsViewModel,
            imageLoader: imageLoader
        )
        bookDetailsViewController.title = "Details"
        bookDetailsViewController.view.backgroundColor = .systemBackground
        return bookDetailsViewController
    }
    
    func makeStatisticsViewController() -> StatisticsViewController {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.title = "Statistics"
        statisticsViewController.view.backgroundColor = .systemBackground
        return statisticsViewController
    }
}
