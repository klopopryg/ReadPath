//
//  SceneDelegate.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let dependencyContainer = DependencyContainer()
        let appCoordinator = AppCoordinator(window: window, dependencyContainer: dependencyContainer)
        self.appCoordinator = appCoordinator
        self.window = window
        appCoordinator.start()
    }
}

