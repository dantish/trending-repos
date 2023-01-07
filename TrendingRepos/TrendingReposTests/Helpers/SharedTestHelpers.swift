//
//  SharedTestHelpers.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation
import TrendingRepos

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func uniqueRepo() -> Repo {
    Repo(
        id: UUID(),
        name: "any name",
        description: "any description",
        language: "any language",
        starsCount: 100,
        owner: RepoOwner(
            id: UUID(),
            username: "any username",
            avatarUrl: anyURL()
        )
    )
}
