//
//  TrendingReposErrorView.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit
import Lottie

final class TrendingReposErrorView: UIView {

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            isHidden = false
        }
    }

    var message: String? {
        get {
            messageLabel.text
        }
        set {
            messageLabel.text = newValue
            isHidden = false
        }
    }

    @IBOutlet private weak var animationView: LottieAnimationView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        configureAnimationView()
        configureRetryButton()
    }

    private func configureAnimationView() {
        animationView.animation = LottieAnimation.named("SomethingWentWrongAnimation", bundle: Bundle(for: Self.self))
        animationView.loopMode = .loop
    }

    private func configureRetryButton() {
        retryButton.layer.cornerRadius = 6
        retryButton.layer.borderColor = UIColor.systemGreen.cgColor
        retryButton.layer.borderWidth = 1
    }
}
