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
        let trendingReposController = makeTrendingReposViewController()
        trendingReposController.title = TrendingReposPresenter.title
        trendingReposController.onRefresh = {
            _ = reposLoader()
        }
        return trendingReposController
    }

    private static func makeTrendingReposViewController() -> TrendingReposViewController {
        let bundle = Bundle(for: TrendingReposViewController.self)
        let storyboard = UIStoryboard(name: "TrendingRepos", bundle: bundle)
        return storyboard.instantiateInitialViewController() as! TrendingReposViewController
    }
}
