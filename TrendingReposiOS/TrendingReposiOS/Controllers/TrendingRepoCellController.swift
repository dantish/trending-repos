//
//  TrendingRepoCellController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit

public final class TrendingRepoCellController: NSObject {
    private let viewModel: TrendingRepoViewModel

    public init(viewModel: TrendingRepoViewModel) {
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
