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

    func test_loadReposCompletion_rendersSuccessfullyLoadedRepos() {
        let repo0 = makeRepo(
            name: "name 0",
            ownerUsername: "username 0"
        )
        let repo1 = makeRepo(
            name: "name 1",
            ownerUsername: "username 1"
        )
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeReposLoading(with: [repo0], at: 0)
        assertThat(sut, isRendering: [repo0])

        sut.simulateUserInitiatedReposReload()
        loader.completeReposLoading(with: [repo0, repo1], at: 1)
        assertThat(sut, isRendering: [repo0, repo1])
    }

    func test_loadReposCompletion_rendersSuccessfullyLoadedEmptyReposAfterNonEmptyRepos() {
        let repo0 = makeRepo()
        let repo1 = makeRepo()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeReposLoading(with: [repo0, repo1], at: 0)
        assertThat(sut, isRendering: [repo0, repo1])

        sut.simulateUserInitiatedReposReload()
        loader.completeReposLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }

    func test_loadReposCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let repo0 = makeRepo()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeReposLoading(with: [repo0], at: 0)
        assertThat(sut, isRendering: [repo0])

        sut.simulateUserInitiatedReposReload()
        loader.completeReposLoadingWithError(at: 1)
        assertThat(sut, isRendering: [repo0])
    }

    func test_loadReposCompletion_rendersErrorUntilRetry() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingError, "Expected error to be hidden once view is loaded")
        XCTAssertNil(sut.errorTitle, "Expected no error title once loading is loaded")
        XCTAssertNil(sut.errorMessage, "Expected no error message once view is loaded")

        loader.completeReposLoadingWithError(at: 0)
        XCTAssertTrue(sut.isShowingError, "Expected error to be shown once loading completes with error")
        XCTAssertNotNil(sut.errorTitle, "Expected error title once loading completes with error")
        XCTAssertNotNil(sut.errorMessage, "Expected error message once loading completes with error")

        sut.simulateRetryAction()
        XCTAssertFalse(sut.isShowingError, "Expected error to be hidden on retry action")
        XCTAssertNil(sut.errorTitle, "Expected no error title on retry action")
        XCTAssertNil(sut.errorMessage, "Expected no error message on retry action")
    }

    func test_loadReposCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeReposLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_repoView_loadsAvatarURLWhenVisible() {
        let repo0 = makeRepo(ownerAvatarUrl: URL(string: "http://url-0.com")!)
        let repo1 = makeRepo(ownerAvatarUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeReposLoading(with: [repo0, repo1])

        XCTAssertEqual(loader.loadedAvatarURLs, [], "Expected no avatar URL requests until views become visible")

        sut.simulateRepoViewVisible(at: 0)
        XCTAssertEqual(loader.loadedAvatarURLs, [repo0.owner.avatarUrl], "Expected first avatar URL request once first view becomes visible")

        sut.simulateRepoViewVisible(at: 1)
        XCTAssertEqual(loader.loadedAvatarURLs, [repo0.owner.avatarUrl, repo1.owner.avatarUrl], "Expected second avatar URL request once second view also becomes visible")
    }

    func test_repoViewAvatarPlaceholder_isVisibleWhileLoadingAvatarOrWhenLoadingFailed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeReposLoading(with: [makeRepo(), makeRepo()])

        let view0 = sut.simulateRepoViewVisible(at: 0)
        let view1 = sut.simulateRepoViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingAvatarPlaceholder, true, "Expected avatar placeholder for first view while loading first avatar")
        XCTAssertEqual(view1?.isShowingAvatarPlaceholder, true, "Expected avatar placeholder for second view while loading second avatar")

        loader.completeAvatarLoading(with: anyAvatarData(), at: 0)
        XCTAssertEqual(view0?.isShowingAvatarPlaceholder, false, "Expected no avatar placeholder for first view once first avatar loading completes successfully")
        XCTAssertEqual(view1?.isShowingAvatarPlaceholder, true, "Expected no avatar placeholder state change for second view once first avatar loading completes successfully")

        loader.completeAvatarLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingAvatarPlaceholder, false, "Expected no avatar placeholder state change for first view once second avatar loading completes with error")
        XCTAssertEqual(view1?.isShowingAvatarPlaceholder, true, "Expected avatar placeholder for second view once second avatar loading completes with error")
    }

    func test_repoView_rendersAvatarLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeReposLoading(with: [makeRepo(), makeRepo()])

        let view0 = sut.simulateRepoViewVisible(at: 0)
        let view1 = sut.simulateRepoViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedAvatar, .none, "Expected no avatar for first view while loading first avatar")
        XCTAssertEqual(view1?.renderedAvatar, .none, "Expected no avatar for second view while loading second avatar")

        let avatarData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeAvatarLoading(with: avatarData0, at: 0)
        XCTAssertEqual(view0?.renderedAvatar, avatarData0, "Expected avatar for first view once first avatar loading completes successfully")
        XCTAssertEqual(view1?.renderedAvatar, .none, "Expected no avatar state change for second view once first avatar loading completes successfully")

        let avatarData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeAvatarLoading(with: avatarData1, at: 1)
        XCTAssertEqual(view0?.renderedAvatar, avatarData0, "Expected no avatar state change for first view once second avatar loading completes successfully")
        XCTAssertEqual(view1?.renderedAvatar, avatarData1, "Expected avatar for second view once second avatar loading completes successfully")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TrendingReposViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TrendingReposUIComposer.trendingReposComposedWith(reposLoader: loader.loadPublisher, avatarLoader: loader.loadAvatarPublisher)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return (sut, loader)
    }

    private func makeRepo(
        name: String = "any name",
        description: String? = nil,
        language: String? = nil,
        starsCount: Int = 100,
        ownerUsername: String = "any username",
        ownerAvatarUrl: URL = URL(string: "http://any-url.com")!
    ) -> Repo {
        Repo(
            id: UUID(),
            name: name,
            description: description,
            language: language,
            starsCount: starsCount,
            owner: RepoOwner(
                id: UUID(),
                username: ownerUsername,
                avatarUrl: ownerAvatarUrl
            )
        )
    }

    private func anyAvatarData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }

    private class LoaderSpy {
        // MARK: - Repos Loader

        private var reposRequests = [PassthroughSubject<[Repo], Error>]()

        var loadReposCallCount: Int {
            reposRequests.count
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

        // MARK: - Owner's Avatar Loader

        private var avatarRequests = [(url: URL, publisher: PassthroughSubject<Data, Error>)]()

        var loadedAvatarURLs: [URL] {
            avatarRequests.map(\.url)
        }

        func loadAvatarPublisher(from url: URL) -> AnyPublisher<Data, Error> {
            let publisher = PassthroughSubject<Data, Error>()
            avatarRequests.append((url, publisher))
            return publisher.eraseToAnyPublisher()
        }

        func completeAvatarLoading(with avatarData: Data = Data(), at index: Int = 0) {
            avatarRequests[index].publisher.send(avatarData)
        }

        func completeAvatarLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            avatarRequests[index].publisher.send(completion: .failure(error))
        }
    }

}
