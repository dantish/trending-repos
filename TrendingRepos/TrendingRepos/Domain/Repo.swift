//
//  TrendingRepo.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import Foundation

public struct Repo: Hashable {
    public let id: UUID
    public let name: String
    public let description: String?
    public let language: String?
    public let starsCount: Int
    public let owner: RepoOwner

    public init(id: UUID, name: String, description: String?, language: String?, starsCount: Int, owner: RepoOwner) {
        self.id = id
        self.name = name
        self.description = description
        self.language = language
        self.starsCount = starsCount
        self.owner = owner
    }
}
