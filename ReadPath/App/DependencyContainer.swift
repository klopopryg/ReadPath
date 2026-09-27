//
//  DependencyContainer.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

final class DependencyContainer {
    func makeDiscoverViewController() -> UIViewController {
        let discoverViewModel = DiscoverViewModel()
        let discoverViewController = DiscoverViewController(
            discoverViewModel: discoverViewModel
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
