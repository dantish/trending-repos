//
//  TrendingReposViewAdapter.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import UIKit
import Combine
import TrendingRepos
import TrendingReposiOS

final class TrendingReposViewAdapter: TrendingReposView {
    private weak var controller: TrendingReposViewController?
    private let avatarLoader: (URL) -> AnyPublisher<Data, Error>

    init(controller: TrendingReposViewController, avatarLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.avatarLoader = avatarLoader
    }

    func display(_ viewModel: TrendingReposViewModel) {
        controller?.display(viewModel.repos.map { repo in
            let adapter = TrendingRepoAvatarDataLoaderPresentationAdapter<WeakRefVirtualProxy<TrendingRepoCellController>, UIImage>(
                repo: repo,
                avatarLoader: avatarLoader
            )

            let view = TrendingRepoCellController()
            view.onDidLoad = adapter.didRequestAvatar

            adapter.presenter = TrendingRepoPresenter<WeakRefVirtualProxy<TrendingRepoCellController>, UIImage>(
                view: WeakRefVirtualProxy(view),
                avatarImageTransformer: UIImage.init
            )

            return view
        })
    }
}
