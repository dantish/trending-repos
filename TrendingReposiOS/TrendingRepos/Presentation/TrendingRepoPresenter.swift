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
    private let avatarImageTransformer: (Data) -> AvatarImage?

    public init(view: View, avatarImageTransformer: @escaping (Data) -> AvatarImage?) {
        self.view = view
        self.avatarImageTransformer = avatarImageTransformer
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

    public func didFinishLoadingAvatarImageData(with data: Data, for repo: Repo) {
        let avatarImage = avatarImageTransformer(data)
        view.display(TrendingRepoViewModel(
            name: repo.name,
            description: repo.description,
            language: repo.language,
            starsCount: String(repo.starsCount),
            ownerName: repo.owner.username,
            ownerAvatar: avatarImage))
    }
}
