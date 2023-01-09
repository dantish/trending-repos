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

    @discardableResult
    func simulateRepoViewVisible(at index: Int) -> TrendingRepoCell? {
        return repoView(at: index) as? TrendingRepoCell
    }

    var isShowingLoadingIndicator: Bool {
        guard let items = (tableView.dataSource as? DataSource)?.snapshot().itemIdentifiers, !items.isEmpty else { return false }

        return items.allSatisfy { item in
            switch item {
            case .loading: return true
            default: return false
            }
        }
    }

    var isShowingUserInitiatedLoadingIndicator: Bool {
        tableView.refreshControl?.isRefreshing ?? false
    }

    var isShowingError: Bool {
        !errorView.isHidden
    }

    var errorTitle: String? {
        errorView.title
    }

    var errorMessage: String? {
        errorView.message
    }

    func simulateRetryAction() {
        errorView.retryButton.simulate(event: .touchUpInside)
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
