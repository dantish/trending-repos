//
//  OwnerAvatarDataMapperTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
import TrendingRepos

class OwnerAvatarDataMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try OwnerAvatarDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: code))
            )
        }
    }

}
