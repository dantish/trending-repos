//
//  TrendingRepoViewModel.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit

public struct TrendingRepoViewModel: Hashable {
    public let name: String
    public let description: String
    public let language: String
    public let starsCount: String
    public let ownerName: String
    public let ownerAvatar: UIImage
}
