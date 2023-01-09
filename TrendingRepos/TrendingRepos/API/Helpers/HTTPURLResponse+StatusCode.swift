//
//  HTTPURLResponse+StatusCode.swift
//  TrendingRepos
//
//  Created by Daniel Tischenko on 09.01.2023.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
