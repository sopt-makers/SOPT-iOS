//
//  PartRankingVC.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/03/31.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import StampFeatureInterface
import BaseFeatureDependency

public class PartRankingVC: UIViewController, PartRankingViewControllable {

  // MARK: - Properties

  public var viewModel: PartRankingViewModel!
  private var cancelBag = CancelBag()

  lazy var dataSource: UICollectionViewDiffableDataSource<RankingSection, AnyHashable>! = nil

  // MARK: - RankingCoordinatable

  public var onCellTap: ((String, String) -> Void)?
  public var onSwiped: (() -> Void)?
  public var onNaviBackTap: (() -> Void)?

  // MARK: - UI Components

  lazy var naviBar = STNavigationBar(self, type: .titleWithLeftButton, ignorePopAction: true)
    .setTitleTypoStyle(.SoptampFont.h2)
    .setTitle("파트별 랭킹")
    .setRightButton(.none)

  private lazy var rankingCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    cv.showsVerticalScrollIndicator = true
    cv.backgroundColor = .white
    cv.refreshControl = refresher
    return cv
  }()

  private let refresher: UIRefreshControl = {
    let rf = UIRefreshControl()
    return rf
  }()

  // MARK: - View Life Cycle
  private let rankingViewType: RankingViewType

  init(rankingViewType: RankingViewType) {
    self.rankingViewType = rankingViewType

    super.init(nibName: nil, bundle: nil)

    guard case .currentGeneration(let info) = rankingViewType else { return }

    let navigationTitle = String(describing: info.currentGeneration) + "기 랭킹"
    self.naviBar.setTitle(navigationTitle)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
    self.setLayout()
    self.setDelegate()
    self.setGesture()
    self.registerCells()
    self.bindViews()
    self.bindViewModels()
    self.setDataSource()
  }
}

// MARK: - UI & Layouts

extension PartRankingVC {

  private func setUI() {
    self.view.backgroundColor = .white
    self.navigationController?.isNavigationBarHidden = true
  }

  private func setLayout() {
    self.view.addSubviews(naviBar, rankingCollectionView)

    naviBar.snp.makeConstraints { make in
      make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
    }

    rankingCollectionView.snp.makeConstraints { make in
      make.top.equalTo(naviBar.snp.bottom).offset(4)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

// MARK: - Methods

extension PartRankingVC {

  private func bindViews() {
    naviBar.leftButtonTapped
      .withUnretained(self)
      .sink { owner, _ in
        owner.onNaviBackTap?()
      }.store(in: cancelBag)
  }

  private func bindViewModels() {
    let refreshStarted = refresher.publisher(for: .valueChanged)
      .mapVoid()
      .asDriver()

    let input = PartRankingViewModel.Input(
      viewDidLoad: Driver.just(()),
      refreshStarted: refreshStarted
    )

    let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
  }

  private func setDelegate() {
    rankingCollectionView.delegate = self
  }

  private func setGesture() {
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeBack(_:)))
    swipeGesture.delegate = self
    self.rankingCollectionView.addGestureRecognizer(swipeGesture)
  }

  @objc
  private func swipeBack(_ sender: UIPanGestureRecognizer) {
    let velocity = sender.velocity(in: rankingCollectionView)
    let velocityMinimum: CGFloat = 1000
    guard let navigation = self.navigationController else { return }
    let isScrollY: Bool = abs(velocity.x) > abs(velocity.y) + 200
    let isNotRootView = navigation.viewControllers.count >= 2
    if velocity.x >= velocityMinimum
        && isNotRootView
        && isScrollY {
      self.rankingCollectionView.isScrollEnabled = false
      self.onSwiped?()
    }
  }

  private func registerCells() {
    RankingChartCVC.register(target: rankingCollectionView)
    RankingListCVC.register(target: rankingCollectionView)
  }

  private func setDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: rankingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch RankingSection.type(indexPath.section) {
      case .chart:
        guard let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingChartCVC.className, for: indexPath) as? RankingChartCVC,
              let chartCellModel = itemIdentifier as? RankingChartModel else { return UICollectionViewCell() }
        chartCell.setData(model: chartCellModel)
        chartCell.balloonTapped = { [weak self] balloonModel in
          guard let self = self else { return }
          let item = balloonModel.toRankingListTapItem()
          self.onCellTap?(item.username, item.sentence)
        }
        return chartCell

      case .list:
        guard let rankingListCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingListCVC.className, for: indexPath) as? RankingListCVC,
              let rankingListCellModel = itemIdentifier as? RankingModel else { return UICollectionViewCell() }
        rankingListCell.setData(model: rankingListCellModel,
                                rank: indexPath.row + 1 + 3)

        return rankingListCell
      }
    })
  }

  func applySnapshot(model: [RankingModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<RankingSection, AnyHashable>()
    snapshot.appendSections([.chart, .list])
    guard model.count >= 4 else { return }
    guard let chartCellModels = Array(model[0...2]) as? [RankingModel],
          let rankingListModel = Array(model[3...model.count-1]) as? [RankingModel] else { return }
    let chartCellModel = RankingChartModel.init(ranking: chartCellModels)
    snapshot.appendItems([chartCellModel], toSection: .chart)
    snapshot.appendItems(rankingListModel, toSection: .list)
    dataSource.apply(snapshot, animatingDifferences: false)
    self.view.setNeedsLayout()
  }

  private func endRefresh() {
    self.refresher.endRefreshing()
  }
}

extension PartRankingVC: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard indexPath.section >= 1 else { return }

    guard let tappedCell = collectionView.cellForItem(at: indexPath) as? RankingListTappable,
          let item = tappedCell.getModelItem() else { return }
    self.onCellTap?(item.username, item.sentence)
  }
}

extension PartRankingVC: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    true
  }
}
