//
//  TrendingRepoViewModel.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public struct TrendingRepoViewModel<AvatarImage> {
    public let name: String
    public let description: String?
    public let language: String?
    public let starsCount: String
    public let ownerName: String
    public let ownerAvatar: AvatarImage?
}
