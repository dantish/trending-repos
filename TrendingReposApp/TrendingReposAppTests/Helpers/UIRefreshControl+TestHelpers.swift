//
//  UIRefreshControl+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
