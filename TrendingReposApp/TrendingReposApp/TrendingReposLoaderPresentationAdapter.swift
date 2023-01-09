//
//  TrendingReposLoaderPresentationAdapter.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Combine
import TrendingRepos

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
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingRepos(with: error)
                    }
                }, receiveValue: { [weak self] repos in
                    self?.presenter?.didFinishLoadingRepos(with: repos)
                })
    }
}
