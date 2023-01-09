//
//  ReposMapperTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
import TrendingRepos

class ReposMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = try! JSONSerialization.data(withJSONObject: ["items": []])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ReposMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try ReposMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = try! JSONSerialization.data(withJSONObject: ["items": []])

        let result = try ReposMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: uniqueID(),
            name: "a name",
            starsCount: 0,
            ownerId: uniqueID(),
            ownerUsername: "a username",
            ownerAvatarUrl: URL(string: "http://a-url.com")!
        )

        let item2 = makeItem(
            id: uniqueID(),
            name: "another name",
            description: "another description",
            language: "another language",
            starsCount: 100,
            ownerId: uniqueID(),
            ownerUsername: "another username",
            ownerAvatarUrl: URL(string: "http://another-url.com")!
        )

        let json = try! JSONSerialization.data(withJSONObject: ["items": [item1.json, item2.json]])

        let result = try ReposMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: - Helpers

    private func makeItem(
        id: Int,
        name: String,
        description: String? = nil,
        language: String? = nil,
        starsCount: Int,
        ownerId: Int,
        ownerUsername: String,
        ownerAvatarUrl: URL
    ) -> (model: Repo, json: [String: Any]) {
        let item = Repo(
            id: id,
            name: name,
            description: description,
            language: language,
            starsCount: starsCount,
            owner: RepoOwner(
                id: ownerId,
                username: ownerUsername,
                avatarUrl: ownerAvatarUrl
            )
        )

        let json = [
            "id": id,
            "name": name,
            "description": description as Any,
            "language": language as Any,
            "stargazers_count": starsCount,
            "owner": [
                "id": ownerId,
                "login": ownerUsername,
                "avatar_url": ownerAvatarUrl.absoluteString
            ]
        ].compactMapValues { $0 }

        return (item, json)
    }

}
