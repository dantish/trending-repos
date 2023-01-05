//
//  TrendingReposViewController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import UIKit
import Lottie

public final class TrendingReposViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var errorView: UIView!
    @IBOutlet private(set) weak var errorAnimationView: LottieAnimationView!
    @IBOutlet private(set) weak var errorTitle: UILabel!
    @IBOutlet private(set) weak var errorMessage: UILabel!
    @IBOutlet private(set) weak var retryButton: UIButton!

    private lazy var dataSource: UITableViewDiffableDataSource<Int, Int> = {
        .init(tableView: tableView) { (tableView, indexPath, _) in
            tableView.dequeueReusableCell(withIdentifier: "TrendingRepoLoadingCell", for: indexPath)
        }
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureRetryButton()
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
    }

    private func configureRetryButton() {
        retryButton.layer.cornerRadius = 6
        retryButton.layer.borderColor = UIColor.systemGreen.cgColor
        retryButton.layer.borderWidth = 1
    }

    public func display(_ viewModel: TrendingReposLoadingViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0..<20), toSection: 0)

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }

    public func display(_ viewModel: TrendingReposErrorViewModel) {
        errorAnimationView.animation = LottieAnimation.named("SomethingWentWrongAnimation", bundle: Bundle(for: Self.self))
        errorAnimationView.loopMode = .loop
        errorAnimationView.play()

        errorTitle.text = viewModel.title
        errorMessage.text = viewModel.message

        errorView.isHidden = false
    }

}
