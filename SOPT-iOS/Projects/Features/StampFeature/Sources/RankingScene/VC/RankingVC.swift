//
//  RankingVC.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

import Combine
import SnapKit
import Then

import StampFeatureInterface

public class RankingVC: UIViewController, RankingViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: RankingViewModel!
    private var cancelBag = CancelBag()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<RankingSection, AnyHashable>! = nil
    
    // MARK: - RankingCoordinatable
    
    public var onCellTap: ((String, String) -> Void)?
    public var onNaviBackTap: (() -> Void)?
    
    // MARK: - UI Components
    
    lazy var naviBar = STNavigationBar(self, type: .titleWithLeftButton, ignorePopAction: true)
        .setTitleTypoStyle(.SoptampFont.h2)
        .setTitle("랭킹")
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
    
    private lazy var showMyRankingFloatingButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 27.adjustedH
        bt.backgroundColor = DSKitAsset.Colors.soptampPurple300.color
        bt.titleLabel?.setTypoStyle(.SoptampFont.h2)
        let attributedStr = NSMutableAttributedString(string: "내 랭킹 보기")
        let style = NSMutableParagraphStyle()
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: 0, range: NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedStr.length))
        bt.setAttributedTitle(attributedStr, for: .normal)
        return bt
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
        self.registerCells()
        self.bindViews()
        self.bindViewModels()
        self.setDataSource()
    }
}

// MARK: - UI & Layouts

extension RankingVC {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        self.view.addSubviews(naviBar, rankingCollectionView, showMyRankingFloatingButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        rankingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        showMyRankingFloatingButton.snp.makeConstraints { make in
            make.width.equalTo(143.adjusted)
            make.height.equalTo(54.adjustedH)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18.adjustedH)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RankingVC {
    
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
        
        let showRankingButtonTapped = self.showMyRankingFloatingButton
            .publisher(for: .touchUpInside)
            .filter { _ in self.rankingCollectionView.indexPathsForVisibleItems.count > 5 }
            .mapVoid()
            .asDriver()
        
        let input = RankingViewModel.Input(
            viewDidLoad: Driver.just(()),
            refreshStarted: refreshStarted,
            showMyRankingButtonTapped: showRankingButtonTapped
        )
        
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$rankingListModel
            .dropFirst(2)
            .withUnretained(self)
            .sink { owner, model in
                owner.applySnapshot(model: model)
                owner.endRefresh()
            }.store(in: self.cancelBag)
        
        output.$myRanking
            .dropFirst()
            .map { IndexPath(item: $0.item, section: $0.section)}
            .withUnretained(self)
            .sink { owner, indexPath in
                owner.rankingCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }.store(in: self.cancelBag)
    }
    
    private func setDelegate() {
        rankingCollectionView.delegate = self
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

extension RankingVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section >= 1 else { return }
        
        guard let tappedCell = collectionView.cellForItem(at: indexPath) as? RankingListTappable,
              let item = tappedCell.getModelItem() else { return }
        self.onCellTap?(item.username, item.sentence)
    }
}

extension RankingVC: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
