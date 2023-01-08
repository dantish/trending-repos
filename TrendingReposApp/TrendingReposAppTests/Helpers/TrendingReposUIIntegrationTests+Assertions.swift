//
//  TrendingReposUIIntegrationTests+Assertions.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
import TrendingRepos
import TrendingReposiOS

extension TrendingReposUIIntegrationTests {
    func assertThat(_ sut: TrendingReposViewController, isRendering repos: [Repo], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedRepoViews() == repos.count else {
            return XCTFail("Expected \(repos.count) images, got \(sut.numberOfRenderedRepoViews()) instead.", file: file, line: line)
        }

        repos.enumerated().forEach { index, repo in
            assertThat(sut, hasViewConfiguredFor: repo, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: TrendingReposViewController, hasViewConfiguredFor repo: Repo, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.repoView(at: index)

        guard let cell = view as? TrendingRepoCell else {
            return XCTFail("Expected \(TrendingRepoCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.nameText, repo.name, "Expected name text to be \(String(describing: repo.name)) for repo view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.ownerUsernameText, repo.owner.username, "Expected owner username text to be \(String(describing: repo.owner.username)) for repo view at index (\(index)", file: file, line: line)
    }
}
