//
//  TrendingReposUIComposer.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import UIKit
import TrendingRepos
import TrendingReposiOS

public final class TrendingReposUIComposer {
    private init() {}

    public static func trendingRepos() -> TrendingReposViewController {
        let bundle = Bundle(for: TrendingReposViewController.self)
        let storyboard = UIStoryboard(name: "TrendingRepos", bundle: bundle)
        let trendingReposController = storyboard.instantiateInitialViewController() as! TrendingReposViewController
        trendingReposController.title = TrendingReposPresenter.title
        return trendingReposController
    }
}
