//
//  TrendingRepoAvatarDataLoaderPresentationAdapter.swift
//  TrendingReposApp
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import Foundation
import Combine
import TrendingRepos

final class TrendingRepoAvatarDataLoaderPresentationAdapter<View: TrendingRepoView, AvatarImage> where View.AvatarImage == AvatarImage {
    private let repo: Repo
    private let avatarLoader: (URL) -> AnyPublisher<Data, Error>
    private var cancellable: Cancellable?

    var presenter: TrendingRepoPresenter<View, AvatarImage>?

    init(repo: Repo, avatarLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.repo = repo
        self.avatarLoader = avatarLoader
    }

    func didRequestAvatar() {
        presenter?.didStartLoadingAvatarImageData(for: repo)
        avatarLoader(repo.owner.avatarUrl)
    }
}
