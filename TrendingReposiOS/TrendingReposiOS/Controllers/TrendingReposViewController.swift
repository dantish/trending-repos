//
//  TrendingReposViewController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import UIKit

public final class TrendingReposViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Int> = {
        .init(tableView: tableView) { (tableView, indexPath, _) in
            tableView.dequeueReusableCell(withIdentifier: "TrendingRepoLoadingCell", for: indexPath)
        }
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
    }

    public func display(_ viewModel: TrendingReposLoadingViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0..<20), toSection: 0)

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }

}
