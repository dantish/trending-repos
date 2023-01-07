//
//  TrendingRepoPresenter.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public protocol TrendingRepoView {
    associatedtype AvatarImage

    func display(_ viewModel: TrendingRepoViewModel<AvatarImage>)
}

public final class TrendingRepoPresenter<View: TrendingRepoView, AvatarImage> where View.AvatarImage == AvatarImage {
    private let view: View

    public init(view: View) {
        self.view = view
    }

    public func didStartLoadingAvatarImageData(for repo: Repo) {
        view.display(TrendingRepoViewModel(
            name: repo.name,
            description: repo.description,
            language: repo.language,
            starsCount: String(repo.starsCount),
            ownerName: repo.owner.username,
            ownerAvatar: nil))
    }
}
