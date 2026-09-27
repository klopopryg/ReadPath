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
}
