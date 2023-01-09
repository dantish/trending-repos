//
//  ReposMapperTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
import TrendingRepos

class ReposMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = try! JSONSerialization.data(withJSONObject: ["items": []])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ReposMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

}
