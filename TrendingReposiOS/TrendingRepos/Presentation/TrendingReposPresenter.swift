//
//  TrendingReposPresenter.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public protocol TrendingReposView {
    func display(_ viewModel: TrendingReposViewModel)
}

public final class TrendingReposPresenter {
    public init(trendingReposView: TrendingReposView) {}

    public static var title: String { "Trending" }
}
