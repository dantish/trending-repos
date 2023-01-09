//
//  TrendingRepoCell+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import UIKit
@testable import TrendingReposiOS

extension TrendingRepoCell {
    var isShowingAvatarPlaceholder: Bool {
        ownerAvatarImageView.image == avatarPlaceholder
    }
    
    var nameText: String? {
        nameLabel.text
    }

    var ownerUsernameText: String? {
        ownerNameLabel.text
    }

    var renderedAvatar: Data? {
        guard !isShowingAvatarPlaceholder else { return nil }

        return ownerAvatarImageView.image?.pngData()
    }
}
