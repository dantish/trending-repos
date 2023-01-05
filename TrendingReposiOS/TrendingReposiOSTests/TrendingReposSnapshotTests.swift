//
//  TrendingReposSnapshotTests.swift
//  TrendingReposiOSTests
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import XCTest
@testable import TrendingReposiOS

final class TrendingReposSnapshotTests: XCTestCase {

    func test_trendingReposWithLoadingState() {
        let sut = makeSUT()

        sut.display(TrendingReposLoadingViewModel(isLoading: true))

        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "TRENDING_REPOS_WITH_LOADING_STATE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "TRENDING_REPOS_WITH_LOADING_STATE_dark")
    }

    private func makeSUT() -> TrendingReposViewController {
        let bundle = Bundle(for: TrendingReposViewController.self)
        let storyboard = UIStoryboard(name: "TrendingRepos", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! TrendingReposViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

}
