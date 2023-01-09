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

        private struct Item: Decodable {}
    }

    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Repo] {
        guard response.isOK, let _ = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return []
    }
}

private extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }

}
