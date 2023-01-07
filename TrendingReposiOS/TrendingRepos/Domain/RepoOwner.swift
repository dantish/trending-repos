//
//  RepoOwner.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public struct RepoOwner {
    public let id: UUID
    public let username: String
    public let avatarUrl: URL

    public init(id: UUID, username: String, avatarUrl: URL) {
        self.id = id
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
