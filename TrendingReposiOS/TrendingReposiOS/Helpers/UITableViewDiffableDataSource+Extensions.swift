//
//  UITableViewDiffableDataSource+Extensions.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit

extension UITableViewDiffableDataSource {

    /// The same as `applySnapshotUsingReloadData`, but with backward compatibility.
    func applySnapshotWithReload(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        completion: (() -> Void)? = nil
    ) {
        if #available(iOS 15.0, *) {
            applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            apply(snapshot, completion: completion)
        }
    }
}
