//
//  TrendingRepoCell+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import TrendingReposiOS

extension TrendingRepoCell {
    var nameText: String? {
        nameLabel.text
    }

    var ownerUsernameText: String? {
        ownerNameLabel.text
    }
}
