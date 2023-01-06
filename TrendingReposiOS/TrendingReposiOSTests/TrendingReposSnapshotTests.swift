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

        sut.display(.error(
            title: "Something went wrong..",
            message: "An alien is probably blocking your signal."
        ))

        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "TRENDING_REPOS_WITH_ERROR_STATE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "TRENDING_REPOS_WITH_ERROR_STATE_dark")
    }

    func test_trendingReposWithContent() {
        let sut = makeSUT()

        sut.display(trendingRepos())

        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .light)), named: "TRENDING_REPOS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14Pro(style: .dark)), named: "TRENDING_REPOS_WITH_CONTENT_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> TrendingReposViewController {
        let bundle = Bundle(for: TrendingReposViewController.self)
        let storyboard = UIStoryboard(name: "TrendingRepos", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! TrendingReposViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func trendingRepos() -> [TrendingRepoViewModel] {
        [
            TrendingRepoViewModel(
                name: "retinaface",
                description: "The remake of the https://github.com/biubug6/Pytorch_Retinaface",
                language: "Python",
                starsCount: "115",
                ownerName: "temaus",
                ownerAvatar: UIImage(named: "avatar-1", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "angular-tetris",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "trungk18",
                ownerAvatar: UIImage(named: "avatar-2", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "gpt3-sandbox",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "shreyashankar",
                ownerAvatar: UIImage(named: "avatar-3", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "awesome-gpt3",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "elyase",
                ownerAvatar: UIImage(named: "avatar-4", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "rpi-power-monitor",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "David00",
                ownerAvatar: UIImage(named: "avatar-5", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "getbrains-agent-latest",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "czl0325",
                ownerAvatar: UIImage(named: "avatar-6", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "awesome-ios",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "yogeshojha",
                ownerAvatar: UIImage(named: "avatar-7", in: Bundle(for: Self.self), with: nil)!
            ),
            TrendingRepoViewModel(
                name: "golang",
                description: "Any description",
                language: "Any language",
                starsCount: "100",
                ownerName: "google",
                ownerAvatar: UIImage(named: "avatar-8", in: Bundle(for: Self.self), with: nil)!
            )
        ]
    }

}

private extension TrendingReposViewController {
    func display(_ viewModels: [TrendingRepoViewModel]) {
        display(viewModels.map(TrendingRepoCellController.init))
    }
}
