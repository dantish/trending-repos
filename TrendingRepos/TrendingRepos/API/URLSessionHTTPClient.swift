//
//  URLSessionHTTPClient.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url).resume()
    }
}
