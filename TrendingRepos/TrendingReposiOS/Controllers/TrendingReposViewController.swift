//
//  TrendingReposViewController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import UIKit
import Lottie
import TrendingRepos

public final class TrendingReposViewController: UIViewController {

    private typealias DataSource = UITableViewDiffableDataSource<Int, DataSourceItem>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, DataSourceItem>

    enum DataSourceItem: Hashable {
        case loading(Int)
        case content(TrendingRepoCellController)
    }

    private lazy var dataSource: DataSource = {
        .init(tableView: tableView) { (tableView, indexPath, item) in
            switch item {
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: "TrendingRepoLoadingCell", for: indexPath)

            case let .content(cellController):
                return cellController.tableView(tableView, cellForRowAt: indexPath)
            }
        }
    }()

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var errorView: TrendingReposErrorView!

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
    }

    public func display(_ items: [TrendingRepoCellController]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map(DataSourceItem.content), toSection: 0)

        dataSource.applySnapshotWithReload(snapshot)
    }

    private var numberOfLoadingCells: Int { 20 }

    public func display(_ viewModel: TrendingReposLoadingViewModel) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems((0..<numberOfLoadingCells).map(DataSourceItem.loading), toSection: 0)

        dataSource.applySnapshotWithReload(snapshot)
    }

    public func display(_ viewModel: TrendingReposErrorViewModel) {
        errorView.title = viewModel.title
        errorView.message = viewModel.message
    }

}
