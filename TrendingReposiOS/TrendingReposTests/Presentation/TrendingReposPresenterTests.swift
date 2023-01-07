//
//  TrendingReposPresenterTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
import TrendingRepos

final class TrendingReposPresenterTests: XCTestCase {

    func test_title_isNotEmpty() {
        XCTAssertFalse(TrendingReposPresenter.title.isEmpty)
    }

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TrendingReposPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TrendingReposPresenter(trendingReposView: view)
        return (sut, view)
    }

    private class ViewSpy: TrendingReposView {
        enum Message: Hashable {
            case display(repos: [Repo])
        }

        private(set) var messages: [Message] = []

        func display(_ viewModel: TrendingReposViewModel) {
            messages.append(.display(repos: viewModel.repos))
        }
    }

}

