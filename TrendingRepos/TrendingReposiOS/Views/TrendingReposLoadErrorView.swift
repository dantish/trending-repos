//
//  TrendingReposLoadErrorView.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 06.01.2023.
//

import UIKit
import Lottie

final class TrendingReposLoadErrorView: UIView {

    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
            isHidden = message == nil && newValue == nil
        }
    }

    var message: String? {
        get {
            messageLabel.text
        }
        set {
            messageLabel.text = newValue
            isHidden = title == nil && newValue == nil
        }
    }

    var onRetry: (() -> Void)?

    @IBOutlet private(set) weak var animationView: LottieAnimationView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var messageLabel: UILabel!
    @IBOutlet private(set) weak var retryButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        title = nil
        message = nil
        
        configureAnimationView()
        configureRetryButton()
    }

    private func configureAnimationView() {
        animationView.animation = LottieAnimation.named("SomethingWentWrongAnimation", bundle: Bundle(for: Self.self))
        animationView.loopMode = .loop
        animationView.play()
    }

    private func configureRetryButton() {
        retryButton.layer.cornerRadius = 6
        retryButton.layer.borderColor = UIColor.systemGreen.cgColor
        retryButton.layer.borderWidth = 1
    }

    @IBAction private func retry() {
        onRetry?()
    }
}
