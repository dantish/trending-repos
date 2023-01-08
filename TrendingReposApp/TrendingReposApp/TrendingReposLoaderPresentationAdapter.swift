//
//  TrendingReposLoaderPresentationAdapter.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Combine
import TrendingRepos
import TrendingReposiOS

final class TrendingReposLoaderPresentationAdapter {
    private let reposLoader: () -> AnyPublisher<[Repo], Error>
    private var cancellable: Cancellable?
    var presenter: TrendingReposPresenter?

    init(reposLoader: @escaping () -> AnyPublisher<[Repo], Error>) {
        self.reposLoader = reposLoader
    }

    func didRequestTrendingReposRefresh() {
        presenter?.didStartLoadingRepos()
        
        cancellable = reposLoader()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingRepos(with: error)
                    }
                }, receiveValue: { [weak self] _ in
                    self?.presenter?.didFinishLoadingRepos(with: [])
                })
    }
}
