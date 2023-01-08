//
//  TrendingReposViewController+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 08.01.2023.
//

import UIKit
@testable import TrendingReposiOS

extension TrendingReposViewController {
    func simulateUserInitiatedReposReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        guard !tableView.visibleCells.isEmpty else { return false }

        return tableView.visibleCells.allSatisfy { $0.reuseIdentifier == "TrendingRepoLoadingCell" }
    }

    var isShowingUserInitiatedLoadingIndicator: Bool {
        tableView.refreshControl?.isRefreshing ?? false
    }

    func numberOfRenderedRepoViews() -> Int {
        guard !isShowingLoadingIndicator else { return 0 }
        
        return tableView.numberOfRows(inSection: reposSection)
    }

    func repoView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedRepoViews() > row else {
            return nil
        }
        let index = IndexPath(row: row, section: reposSection)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: index)
    }

    private var reposSection: Int { 0 }
}
