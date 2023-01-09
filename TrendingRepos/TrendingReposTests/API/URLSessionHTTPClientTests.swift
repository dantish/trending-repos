//
//  URLSessionHTTPClientTests.swift
//  TrendingReposTests
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import XCTest
import TrendingRepos

class URLSessionHTTPClientTests: XCTestCase {

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.removeStub()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.stub(data: nil, response: nil, error: anyNSError())

        let sut = makeSUT()
        let exp = expectation(description: "Wait for completion")

        var receivedResult: HTTPClient.Result!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        switch receivedResult {
        case .failure:
            break
        default:
            XCTFail("Expected failure, got \(String(describing: receivedResult)) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
