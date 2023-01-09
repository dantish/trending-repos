//
//  TrendingReposUIComposer.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import UIKit
import Combine
import TrendingRepos
import TrendingReposiOS

public final class TrendingReposUIComposer {
    private init() {}

    public static func trendingReposComposedWith(
        reposLoader: @escaping () -> AnyPublisher<[Repo], Error>,
        avatarLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> TrendingReposViewController {
        let presentationAdapter = TrendingReposLoaderPresentationAdapter(reposLoader: reposLoader)

        let trendingReposController = makeTrendingReposViewController()
        trendingReposController.title = TrendingReposPresenter.title
        trendingReposController.onRefresh = presentationAdapter.didRequestTrendingReposRefresh

        presentationAdapter.presenter = TrendingReposPresenter(
            reposView: TrendingReposViewAdapter(controller: trendingReposController, avatarLoader: avatarLoader),
            loadingView: WeakRefVirtualProxy(trendingReposController),
            errorView: WeakRefVirtualProxy(trendingReposController)
        )

        return trendingReposController
    }

    private static func makeTrendingReposViewController() -> TrendingReposViewController {
        let bundle = Bundle(for: TrendingReposViewController.self)
        let storyboard = UIStoryboard(name: "TrendingRepos", bundle: bundle)
        return storyboard.instantiateInitialViewController() as! TrendingReposViewController
    }
}
