//
//  SceneDelegateTests.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
@testable import TrendingReposApp

class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureWindow()

        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }

    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0

        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount = 1
        }
    }

}
