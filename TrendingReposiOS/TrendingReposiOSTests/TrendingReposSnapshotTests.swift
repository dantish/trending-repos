//
//  TrendingReposSnapshotTests.swift
//  TrendingReposiOSTests
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import XCTest
import Lottie
@testable import TrendingReposiOS

final class TrendingReposSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        // Since tests are executed on the main thread,
        // We want the prep work from the Lottie side to be done on the main thread as well,
        // Otherwise we won't see the animation's first frame in snapshots.
        LottieConfiguration.shared.renderingEngine = .mainThread
    }

    func test_trendingReposWithLoadingState() {
        let sut = makeSUT()

        sut.display(TrendingReposLoadingViewModel(isLoading: true))

        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "TRENDING_REPOS_WITH_LOADING_STATE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "TRENDING_REPOS_WITH_LOADING_STATE_dark")
    }

    func test_trendingReposWithErrorState() {
        let sut = makeSUT()

        sut.display(TrendingReposErrorViewModel(
            title: "Something went wrong..",
            message: "An alien is probably blocking your signal."
        ))

        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "TRENDING_REPOS_WITH_ERROR_STATE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "TRENDING_REPOS_WITH_ERROR_STATE_dark")
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
