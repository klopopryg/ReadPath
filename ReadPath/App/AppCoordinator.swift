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
        let discoverViewController = dependencyContainer.makeDiscoverViewController()
        let navigationController = UINavigationController(rootViewController: discoverViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
