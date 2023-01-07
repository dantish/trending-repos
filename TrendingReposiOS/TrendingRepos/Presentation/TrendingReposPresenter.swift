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

public protocol TrendingReposLoadingView {
    func display(_ viewModel: TrendingReposLoadingViewModel)
}

public protocol TrendingReposErrorView {
    func display(_ viewModel: TrendingReposErrorViewModel)
}

public final class TrendingReposPresenter {
    private let reposView: TrendingReposView
    private let loadingView: TrendingReposLoadingView
    private let errorView: TrendingReposErrorView

    public init(reposView: TrendingReposView, loadingView: TrendingReposLoadingView, errorView: TrendingReposErrorView) {
        self.reposView = reposView
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public static var title: String { "Trending" }

    public func didStartLoadingRepos() {
        errorView.display(.noError)
        loadingView.display(TrendingReposLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingRepos(with repos: [Repo]) {
        reposView.display(TrendingReposViewModel(repos: repos))
        loadingView.display(TrendingReposLoadingViewModel(isLoading: false))
    }
}
