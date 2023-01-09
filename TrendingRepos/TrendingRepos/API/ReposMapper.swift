//
//  ReposMapper.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import Foundation

public final class ReposMapper {
    private struct Root: Decodable {
        private let items: [Item]

        private struct Item: Decodable {
            let id: Int
            let name: String
            let description: String?
            let language: String?
            let starsCount: Int
            let owner: Owner

            enum CodingKeys: String, CodingKey {
                case id
                case name
                case description
                case language
                case starsCount = "stargazers_count"
                case owner
            }

            var repo: Repo {
                Repo(
                    id: id,
                    name: name,
                    description: description,
                    language: language,
                    starsCount: starsCount,
                    owner: RepoOwner(
                        id: owner.id,
                        username: owner.login,
                        avatarUrl: owner.avatarUrl
                    )
                )
            }
        }

        private struct Owner: Decodable {
            let id: Int
            let login: String
            let avatarUrl: URL

            enum CodingKeys: String, CodingKey {
                case id
                case login
                case avatarUrl = "avatar_url"
            }
        }

        var repos: [Repo] {
            items.map(\.repo)
        }
    }

    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Repo] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return root.repos
    }
}
