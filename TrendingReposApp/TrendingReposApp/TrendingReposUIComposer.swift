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
        reposLoader: @escaping () -> AnyPublisher<[Repo], Error>
    ) -> TrendingReposViewController {
        let presentationAdapter = TrendingReposLoaderPresentationAdapter(reposLoader: reposLoader)

        let trendingReposController = makeTrendingReposViewController()
        trendingReposController.title = TrendingReposPresenter.title
        trendingReposController.onRefresh = presentationAdapter.didRequestTrendingReposRefresh

        presentationAdapter.presenter = TrendingReposPresenter(
            reposView: TrendingReposViewAdapter(controller: trendingReposController),
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

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TrendingReposErrorView where T: TrendingReposErrorView {
    func display(_ viewModel: TrendingReposErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: TrendingReposLoadingView where T: TrendingReposLoadingView {
    func display(_ viewModel: TrendingReposLoadingViewModel) {
        object?.display(viewModel)
    }
}
