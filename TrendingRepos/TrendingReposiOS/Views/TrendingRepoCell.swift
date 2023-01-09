//
//  TrendingRepoCell.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit

public final class TrendingRepoCell: UITableViewCell {
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var ownerNameLabel: UILabel!
    @IBOutlet private(set) public var ownerAvatarImageView: UIImageView!

    let avatarPlaceholder = UIImage(named: "avatar-placeholder", in: Bundle(for: TrendingRepoCell.self), with: nil)!

    public override func awakeFromNib() {
        super.awakeFromNib()
        setAvatarPlaceholder()
    }

    func setAvatarPlaceholder() {
        ownerAvatarImageView.image = avatarPlaceholder
    }
}
