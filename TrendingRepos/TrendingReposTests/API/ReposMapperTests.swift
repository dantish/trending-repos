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

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try ReposMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = try! JSONSerialization.data(withJSONObject: ["items": []])

        let result = try ReposMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

}
