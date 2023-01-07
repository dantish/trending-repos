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

}

