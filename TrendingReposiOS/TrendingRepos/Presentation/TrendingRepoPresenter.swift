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
    public init(view: View) {}
}
