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

    func test_didStartLoadingAvatarImageData_displaysRepoWithLoadingAvatarImage() {
        let (sut, view) = makeSUT()
        let repo = uniqueRepo()

        sut.didStartLoadingAvatarImageData(for: repo)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, repo.name)
        XCTAssertEqual(message?.description, repo.description)
        XCTAssertEqual(message?.language, repo.language)
        XCTAssertEqual(message?.starsCount, String(repo.starsCount))
        XCTAssertEqual(message?.ownerName, repo.owner.username)
        XCTAssertNil(message?.ownerAvatar)
    }

    func test_didFinishLoadingAvatarImageData_displaysRepoWithoutAvatarImageOnFailedImageTransformation() {
        let (sut, view) = makeSUT(avatarImageTransformer: fail)
        let repo = uniqueRepo()

        sut.didFinishLoadingAvatarImageData(with: Data(), for: repo)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, repo.name)
        XCTAssertEqual(message?.description, repo.description)
        XCTAssertEqual(message?.language, repo.language)
        XCTAssertEqual(message?.starsCount, String(repo.starsCount))
        XCTAssertEqual(message?.ownerName, repo.owner.username)
        XCTAssertNil(message?.ownerAvatar)
    }

    func test_didFinishLoadingAvatarImageData_displaysRepoWithAvatarImageOnSuccessfulImageTransformation() {
        let repo = uniqueRepo()
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(avatarImageTransformer: { _ in transformedData })

        sut.didFinishLoadingAvatarImageData(with: Data(), for: repo)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, repo.name)
        XCTAssertEqual(message?.description, repo.description)
        XCTAssertEqual(message?.language, repo.language)
        XCTAssertEqual(message?.starsCount, String(repo.starsCount))
        XCTAssertEqual(message?.ownerName, repo.owner.username)
        XCTAssertEqual(message?.ownerAvatar, transformedData)
    }

    func test_didFinishLoadingAvatarImageDataWithError_displaysRepoWithoutAvatarImage() {
        let repo = uniqueRepo()
        let (sut, view) = makeSUT()

        sut.didFinishLoadingAvatarImageData(with: anyNSError(), for: repo)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, repo.name)
        XCTAssertEqual(message?.description, repo.description)
        XCTAssertEqual(message?.language, repo.language)
        XCTAssertEqual(message?.starsCount, String(repo.starsCount))
        XCTAssertEqual(message?.ownerName, repo.owner.username)
        XCTAssertNil(message?.ownerAvatar)
    }

    // MARK: - Helpers

    private func makeSUT(
        avatarImageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: TrendingRepoPresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TrendingRepoPresenter(view: view, avatarImageTransformer: avatarImageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }

    private struct AnyImage: Equatable {}

    private class ViewSpy: TrendingRepoView {
        private(set) var messages: [TrendingRepoViewModel<AnyImage>] = []

        func display(_ viewModel: TrendingRepoViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }

}
