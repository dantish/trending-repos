//
//  TrendingRepoCellController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit
import TrendingRepos

public final class TrendingRepoCellController {
    private let id: UUID
    private let viewModel: TrendingRepoViewModel<UIImage>

    public init(id: UUID = UUID(), viewModel: TrendingRepoViewModel<UIImage>) {
        self.id = id
        self.viewModel = viewModel
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingRepoCell", for: indexPath) as! TrendingRepoCell
        cell.nameLabel.text = viewModel.name
        cell.ownerNameLabel.text = viewModel.ownerName
        cell.ownerAvatarImageView.image = viewModel.ownerAvatar
        return cell
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
