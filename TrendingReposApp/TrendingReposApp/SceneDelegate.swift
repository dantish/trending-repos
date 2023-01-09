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

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: TrendingReposUIComposer.trendingReposComposedWith(
                reposLoader: makeRemoteReposLoader,
                avatarLoader: makeRemoteAvatarLoader
            )
        )

        window?.makeKeyAndVisible()
    }

    private func makeRemoteReposLoader() -> AnyPublisher<[Repo], Error> {
        httpClient
            .getPublisher(url: URL(string: "https://api.github.com/search/repositories?q=language=+sort:stars")!)
            .tryMap(ReposMapper.map)
            .eraseToAnyPublisher()
    }

    private func makeRemoteAvatarLoader(url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(url: url)
            .tryMap(OwnerAvatarDataMapper.map)
            .eraseToAnyPublisher()
    }
}

