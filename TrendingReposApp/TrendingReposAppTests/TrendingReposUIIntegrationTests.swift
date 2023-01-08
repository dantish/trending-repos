//
//  TrendingReposUIIntegrationTests.swift
//  TrendingReposUIIntegrationTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
import Combine
import TrendingRepos
import TrendingReposiOS
import TrendingReposApp

final class TrendingReposUIIntegrationTests: XCTestCase {

    func test_trendingReposView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
    }

    func test_loadReposActions_requestReposFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadReposCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadReposCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedReposReload()
        XCTAssertEqual(loader.loadReposCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedReposReload()
        XCTAssertEqual(loader.loadReposCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingIndicator_isVisibleWhileDoingReposReloadNotInitiatedByUser() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeReposLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once initial loading completes successfully")

        sut.simulateUserInitiatedReposReload()
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiates a reload")

        loader.completeReposLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes successfully")

        sut.simulateUserInitiatedReposReload()
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiates another reload")

        loader.completeReposLoadingWithError(at: 2)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_userInitiatedLoadingIndicator_isVisibleWhileDoingReposReloadInitiatedByUser() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingUserInitiatedLoadingIndicator, "Expected no user initiated loading indicator once view is loaded")

        loader.completeReposLoading(at: 0)
        XCTAssertFalse(sut.isShowingUserInitiatedLoadingIndicator, "Expected no user initiated loading indicator once initial loading completes successfully")

        sut.simulateUserInitiatedReposReload()
        XCTAssertTrue(sut.isShowingUserInitiatedLoadingIndicator, "Expected user initiated loading indicator once user initiates a reload")

        loader.completeReposLoading(at: 1)
        XCTAssertFalse(sut.isShowingUserInitiatedLoadingIndicator, "Expected no user initiated loading indicator once user initiated loading completes successfully")

        sut.simulateUserInitiatedReposReload()
        XCTAssertTrue(sut.isShowingUserInitiatedLoadingIndicator, "Expected user initiated loading indicator once user initiates another reload")

        loader.completeReposLoadingWithError(at: 2)
        XCTAssertFalse(sut.isShowingUserInitiatedLoadingIndicator, "Expected no user initiated loading indicator once user initiated loading completes with error")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TrendingReposViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TrendingReposUIComposer.trendingReposComposedWith(reposLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return (sut, loader)
    }

    private class LoaderSpy {
        private var reposRequests = [PassthroughSubject<[Repo], Error>]()

        var loadReposCallCount: Int {
            return reposRequests.count
        }

        func loadPublisher() -> AnyPublisher<[Repo], Error> {
            let publisher = PassthroughSubject<[Repo], Error>()
            reposRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeReposLoading(with repos: [Repo] = [], at index: Int = 0) {
            reposRequests[index].send(repos)
        }

        func completeReposLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            reposRequests[index].send(completion: .failure(error))
        }
    }

}
