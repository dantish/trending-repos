//
//  TrendingReposViewAdapter.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import UIKit
import TrendingRepos
import TrendingReposiOS

final class TrendingReposViewAdapter: TrendingReposView {
    private weak var controller: TrendingReposViewController?

    init(controller: TrendingReposViewController) {
        self.controller = controller
    }

    func display(_ viewModel: TrendingReposViewModel) {
        controller?.display(viewModel.repos.map { repo in
            let view = TrendingRepoCellController()
            let presenter = TrendingRepoPresenter<WeakRefVirtualProxy<TrendingRepoCellController>, UIImage>(
                view: WeakRefVirtualProxy(view),
                avatarImageTransformer: { _ in nil }
            )

            view.onDidLoad = {
                presenter.didStartLoadingAvatarImageData(for: repo)
            }

            return view
        })
    }
}
