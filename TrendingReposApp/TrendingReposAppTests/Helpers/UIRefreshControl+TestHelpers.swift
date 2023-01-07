//
//  UIRefreshControl+TestHelpers.swift
//  TrendingReposAppTests
//
//  Created by Daniel Tischenko on 07.01.2023.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
