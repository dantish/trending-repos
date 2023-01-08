//
//  TrendingReposViewController+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 08.01.2023.
//

@testable import TrendingReposiOS

extension TrendingReposViewController {
    func simulateUserInitiatedReposReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }

    var isShowingLoadingIndicator: Bool {
        tableView.visibleCells.allSatisfy { $0.reuseIdentifier == "TrendingRepoLoadingCell" }
    }

    var isShowingUserInitiatedLoadingIndicator: Bool {
        tableView.refreshControl?.isRefreshing ?? false
    }
}
