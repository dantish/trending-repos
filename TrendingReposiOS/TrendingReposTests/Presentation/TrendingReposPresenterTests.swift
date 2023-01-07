//
//  TrendingReposPresenterTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
@testable import TrendingRepos

final class TrendingReposPresenterTests: XCTestCase {

    func test_title_isNotEmpty() {
        XCTAssertFalse(TrendingReposPresenter.title.isEmpty)
    }

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingRepos_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingRepos()

        XCTAssertEqual(view.messages, [
            .display(errorTitle: .none, errorMessage: .none),
            .display(isLoading: true)
        ])
    }

    func test_didFinishLoadingRepos_displaysReposAndStopsLoading() {
        let (sut, view) = makeSUT()
        let repos = [uniqueRepo(), uniqueRepo()]

        sut.didFinishLoadingRepos(with: repos)

        XCTAssertEqual(view.messages, [
            .display(repos: repos),
            .display(isLoading: false)
        ])
    }

    func test_didFinishLoadingReposWithError_displaysErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()

        sut.didFinishLoadingRepos(with: anyNSError())

        XCTAssertEqual(view.messages, [
            .display(
                errorTitle: TrendingReposPresenter.reposLoadErrorTitle,
                errorMessage: TrendingReposPresenter.reposLoadErrorMessage
            ),
            .display(isLoading: false)
        ])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TrendingReposPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TrendingReposPresenter(reposView: view, loadingView: view, errorView: view)
        return (sut, view)
    }

    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }

    private func uniqueRepo() -> Repo {
        Repo(
            id: UUID(),
            name: "any name",
            description: "any description",
            language: "any language",
            starsCount: 100,
            owner: RepoOwner(
                id: UUID(),
                username: "any username",
                avatarUrl: anyURL()
            )
        )
    }

    private class ViewSpy: TrendingReposView, TrendingReposLoadingView, TrendingReposErrorView {
        enum Message: Hashable {
            case display(repos: [Repo])
            case display(errorTitle: String?, errorMessage: String?)
            case display(isLoading: Bool)
        }

        private(set) var messages: [Message] = []

        func display(_ viewModel: TrendingReposViewModel) {
            messages.append(.display(repos: viewModel.repos))
        }

        func display(_ viewModel: TrendingReposLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }

        func display(_ viewModel: TrendingReposErrorViewModel) {
            messages.append(.display(errorTitle: viewModel.title, errorMessage: viewModel.message))
        }
    }

}

