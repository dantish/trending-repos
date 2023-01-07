//
//  TrendingRepoPresenterTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
import TrendingRepos

class TrendingRepoPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TrendingRepoPresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TrendingRepoPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private struct AnyImage {}

    private class ViewSpy: TrendingRepoView {
        private(set) var messages: [TrendingRepoViewModel<AnyImage>] = []

        func display(_ viewModel: TrendingRepoViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }

}
