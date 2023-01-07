//
//  TrendingReposUIIntegrationTests.swift
//  TrendingReposUIIntegrationTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
import Combine
import TrendingRepos
@testable import TrendingReposiOS
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

        sut.tableView.refreshControl?.allTargets.forEach { target in
            sut.tableView.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
        XCTAssertEqual(loader.loadReposCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.tableView.refreshControl?.allTargets.forEach { target in
            sut.tableView.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
        XCTAssertEqual(loader.loadReposCallCount, 3, "Expected yet another loading request once user initiates another reload")
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
    }

}
