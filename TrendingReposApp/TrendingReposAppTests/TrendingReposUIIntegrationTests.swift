//
//  TrendingReposUIIntegrationTests.swift
//  TrendingReposUIIntegrationTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import XCTest
import TrendingReposiOS
import TrendingReposApp

final class TrendingReposUIIntegrationTests: XCTestCase {

    func test_trendingReposView_hasTitle() {
        let sut = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> TrendingReposViewController {
        let sut = TrendingReposUIComposer.trendingRepos()
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
        return sut
    }

}
