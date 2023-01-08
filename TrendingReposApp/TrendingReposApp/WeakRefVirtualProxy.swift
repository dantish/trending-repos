//
//  WeakRefVirtualProxy.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import TrendingRepos

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
