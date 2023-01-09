//
//  OwnerAvatarDataMapper.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import Foundation

public final class OwnerAvatarDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        throw Error.invalidData
    }
}
