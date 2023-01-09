//
//  TrendingReposViewController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import UIKit
import Lottie
import TrendingRepos

public final class TrendingReposViewController: UIViewController, TrendingReposLoadingView, TrendingReposErrorView {

    typealias DataSource = UITableViewDiffableDataSource<Int, DataSourceItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, DataSourceItem>

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
    private var isUserInitiatedRefresh = false

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var errorView: TrendingReposLoadErrorView!

    public var onRefresh: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        errorView.onRetry = onRefresh
        onRefresh?()
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc private func refresh() {
        isUserInitiatedRefresh = true
        onRefresh?()
    }

    public func display(_ items: [TrendingRepoCellController]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map(DataSourceItem.content), toSection: 0)

        dataSource.applySnapshotWithReload(snapshot)
    }

    private var numberOfLoadingCells: Int { 20 }

    public func display(_ viewModel: TrendingReposLoadingViewModel) {
        guard !isUserInitiatedRefresh else {
            if viewModel.isLoading {
                tableView.refreshControl?.beginRefreshing()
            } else {
                isUserInitiatedRefresh = false
                tableView.refreshControl?.endRefreshing()
            }
            return
        }

        guard viewModel.isLoading else { return }

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
