//
//  RoundedView.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 04.01.2023.
//

import UIKit

class RoundedView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

}
