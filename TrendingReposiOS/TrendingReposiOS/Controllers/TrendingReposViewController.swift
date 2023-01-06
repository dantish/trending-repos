//
//  TrendingReposViewController.swift
//  TrendingReposiOS
//
//  Created by Daniel Tischenko on 03.01.2023.
//

import UIKit
import Lottie

public final class TrendingReposViewController: UIViewController {

    enum DataSourceItem: Hashable {
        case loading(Int)
        case content(TrendingRepoViewModel)
    }

    private typealias DataSource = UITableViewDiffableDataSource<Int, DataSourceItem>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, DataSourceItem>

    private lazy var dataSource: DataSource = {
        .init(tableView: tableView) { (tableView, indexPath, item) in
            switch item {
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: "TrendingRepoLoadingCell", for: indexPath)

            case let .content(repoViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingRepoCell", for: indexPath) as! TrendingRepoCell
                cell.nameLabel.text = repoViewModel.name
                cell.ownerNameLabel.text = repoViewModel.ownerName
                cell.ownerAvatarImageView.image = repoViewModel.ownerAvatar
                return cell
            }
        }
    }()

    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var errorView: UIView!
    @IBOutlet private(set) weak var errorAnimationView: LottieAnimationView!
    @IBOutlet private(set) weak var errorTitle: UILabel!
    @IBOutlet private(set) weak var errorMessage: UILabel!
    @IBOutlet private(set) weak var retryButton: UIButton!

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

    public func display(_ viewModels: [TrendingRepoViewModel]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModels.map(DataSourceItem.content), toSection: 0)

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }

    public func display(_ viewModel: TrendingReposLoadingViewModel) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems((0..<20).map(DataSourceItem.loading), toSection: 0)

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
