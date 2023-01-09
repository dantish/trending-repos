//
//  SceneDelegate.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import UIKit
import Combine
import TrendingRepos
import TrendingReposiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: TrendingReposUIComposer.trendingReposComposedWith(
                reposLoader: { Empty().eraseToAnyPublisher() },
                avatarLoader: { _ in Empty().eraseToAnyPublisher() }
            )
        )

        window?.makeKeyAndVisible()
    }
}

