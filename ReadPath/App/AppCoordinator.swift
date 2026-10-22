//
//  AppCoordinator.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let dependencyContainer: DependencyContainer
    
    
    init(window: UIWindow, dependencyContainer: DependencyContainer) {
        self.window = window
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let tabBar = UITabBarController()
        let discoverNavigationController = makeDiscoverNavigationController()
        discoverNavigationController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        let libraryNavigationController = makeLibraryNavigationController()
        libraryNavigationController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 1)
        let statisticsNavigationController = makeStatisticsNavigationController()
        statisticsNavigationController.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar"), tag: 2)
        tabBar.viewControllers = [discoverNavigationController, libraryNavigationController, statisticsNavigationController]
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        
    }
    
    private func makeDiscoverNavigationController() -> UINavigationController {
        let discoverViewController = dependencyContainer.makeDiscoverViewController()
        let navigationController = UINavigationController(rootViewController: discoverViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        discoverViewController.onBookSelected = { [weak self, weak navigationController] key in
            guard let navigationController else { return }
            self?.showDetails(key: key, navigationControoler: navigationController)
        }
        return navigationController
    }
    
    private func makeLibraryNavigationController() -> UINavigationController {
        let libraryViewController = dependencyContainer.makeLibraryViewController()
        let navigationController = UINavigationController(rootViewController: libraryViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        libraryViewController.onBookSelected = { [weak self, weak libraryViewController] key in
            guard let libraryViewController else { return }
            self?.showDetails(key: key, navigationControoler: navigationController)
        }
        return navigationController
    }
    
    private func makeStatisticsNavigationController() -> UINavigationController {
        let statisticsViewController = dependencyContainer.makeStatisticsViewController()
        let navigationController = UINavigationController(rootViewController: statisticsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func showDetails(key: String, navigationControoler: UINavigationController) {
        let detailsViewController = dependencyContainer.makeDetailsViewController(key: key)
        navigationControoler.pushViewController(detailsViewController, animated: true)
    }
}
