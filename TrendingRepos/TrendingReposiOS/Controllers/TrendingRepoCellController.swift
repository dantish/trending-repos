//
//  TrendingRepoCellController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit
import TrendingRepos

public final class TrendingRepoCellController: TrendingRepoView {
    private let id: UUID
    private var cell: TrendingRepoCell?

    public var onDidLoad: (() -> Void)?

    public init(id: UUID = UUID()) {
        self.id = id
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "TrendingRepoCell", for: indexPath) as? TrendingRepoCell
        onDidLoad?()
        return cell!
    }

    public func display(_ viewModel: TrendingRepoViewModel<UIImage>) {
        cell?.nameLabel.text = viewModel.name
        cell?.ownerNameLabel.text = viewModel.ownerName
        cell?.ownerAvatarImageView.image = viewModel.ownerAvatar
    }
}

extension TrendingRepoCellController: Hashable {
    public static func == (lhs: TrendingRepoCellController, rhs: TrendingRepoCellController) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
