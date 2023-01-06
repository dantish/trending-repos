//
//  TrendingReposErrorViewModel.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 04.01.2023.
//

public struct TrendingReposErrorViewModel {
    public let title: String?
    public let message: String?

    public static func error(title: String, message: String) -> Self {
        .init(title: title, message: message)
    }
}
