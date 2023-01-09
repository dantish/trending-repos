//
//  RepoOwner.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public struct RepoOwner: Hashable {
    public let id: Int
    public let username: String
    public let avatarUrl: URL

    public init(id: Int, username: String, avatarUrl: URL) {
        self.id = id
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
